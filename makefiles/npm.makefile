MAKE_DIR:=./makefile-for-js/makefiles/
CONFIG_DIR := ./makefile-for-js/configs/
include $(MAKE_DIR)/common.makefile

#######################################
# KNOBS
#######################################
USE_GLOBAL :=1

#######################################
# COMMANDS
#######################################
COPY := cp -b --preserve=all

#######################################
# DIRECS and FILES
#######################################
SRC_DIR := ./src# project src
ROOT_MAKES :=$(MAKE_DIR)/root.makefile# project makefiles
SRC_MAKES :=$(MAKE_DIR)/src.makefile# src direc makefiles
NPM_SFX :=.mjs

#GLOBAL_NPM_DIR := /usr/lib/node_modules#may be different like /usr/local/lib
COMPILE_PACKAGES := \
	@babel/cli  \
	@babel/plugin-proposal-class-properties \
	@babel/plugin-transform-object-assign \
	@babel/preset-env \
	@babel/core \
	@babel/plugin-syntax-dynamic-import \
	@babel/plugin-transform-react-jsx \
	@babel/preset-react \
	babel-eslint \
	eslint-plugin-import \
	eslint-plugin-react \
	browserify-global-shim \

HELP +=\n**install-packages**: Install npm development packages (see COMPILE_PACKAGES, USE_GLOBAL). \
    If USE_GLOBAL is defined will install as root globally
.PHONY: install-packages
install-packages:
ifneq ($(USE_GLOBAL),)
	sudo npm i -g $(COMPILE_PACKAGES)
endif
	npm i --save-dev $(COMPILE_PACKAGES)

# TODO make script to make links right way (scoped packages need a real directory). see below
HELP +=\n**global-link**: If `USE_GLOABL` is set create sym links in local `node_modules` so global packages will be found. \
\n    XXX note that `npm link`/(npm developers) is/are way too stupid to use absolute \
\n    directories with the soft links, so if you move your package you may have to rerun.
.PHONY: global-link
global-link:
ifneq ($(USE_GLOBAL),)
	npm link $(COMPILE_PACKAGES)
endif

HELP +=\n**remove-packages**: Undo global-link if `USE_GLOBAL` is set; else `npm remove`.
.PHONY: remove-packages
remove-packages:
ifneq ($(USE_GLOBAL),)
	cd node_modules && rm $(COMPILE_PACKAGES)
else
	npm remove $(COMPILE_PACKAGES)
endif

.PHONY: install
HELP += **install**: Install make files.
install:
	mkdir -p $(SRC_DIR) && $(COPY) $(SRC_MAKES) $(SRC_DIR)
	$(COPY) $(ROOT_MAKES) .

export HELP
