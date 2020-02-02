MAKE_DIR:=./makefile-for-js/makefiles/
CONFIG_DIR := ./makefile-for-js/configs/
include $(MAKE_DIR)/common.makefile

#######################################
# KNOBS
#######################################
HELP_USE += \n\n**USE_GLOBAL**: install devolpment tools globally and keep out of local `node_modules` (lower disk usage for multiple projects.)
USE_GLOBAL ?=1

HELP_USE += \n\n**USE_REACT**: install react packages and configs
USE_REACT ?=1

HELP_USE += \n\n**USE_SYMLINK**: Use symlinks instead of copying files
USE_SYMLINK?=1

#######################################
# COMMANDS
#######################################
COPY := cp -b#preserve permissions, timestamps, make backups i.e ~

#######################################
# DIRECS and FILES
#######################################
SRC_DIR := ./src# project src
ROOT_MAKE :=$(MAKE_DIR)/root.makefile# project makefiles
SRC_MAKE :=$(MAKE_DIR)/src.makefile# src direc makefiles
_NPM_SFX :=.mjs
CONFIGS :=$(CONFIG_DIR)/*$(_NPM_SFX)#

REACT_PACKAGES = react react-dom prop-types

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

HELP +=\n\n**install-packages**: Install npm development packages (see COMPILE_PACKAGES, USE_GLOBAL). \
    If USE_GLOBAL is defined will install as root globally
.PHONY: install-packages
install-packages:
	cp --no-clobber package.json$(_NPM_SFX) package.json
ifneq ($(USE_GLOBAL),)
	sudo npm i -g $(COMPILE_PACKAGES)
else
	npm i --save-dev $(COMPILE_PACKAGES)
endif
ifneq ($(USE_REACT),)
	npm i --save-dev $(REACT_PACKAGES)
endif

# TODO make script to make links right way (scoped packages need a real directory). see below
HELP +=\n\n**global-link**: If `USE_GLOABL` is set create sym links in local `node_modules` so global packages will be found. \
\n    XXX note that `npm link`/(npm developers) is/are way too stupid to use absolute \
\n    directories with the soft links, so if you move your package you may have to rerun.
.PHONY: global-link
global-link:
ifneq ($(USE_GLOBAL),)
	npm link $(COMPILE_PACKAGES)
endif

HELP +=\n\n**remove-packages**: Undo global-link if `USE_GLOBAL` is set; else `npm remove`.
.PHONY: remove-packages
remove-packages:
ifneq ($(USE_GLOBAL),)
	cd node_modules && rm $(COMPILE_PACKAGES)
else
	npm remove $(COMPILE_PACKAGES)
endif

HELP += \n\n**install-files**: Install make and config files.
.PHONY: install-files

install-files:
	mkdir -p $(SRC_DIR)
ifneq ($(USE_SYMLINK),)
	ln -r -s $(SRC_MAKE) $(SRC_DIR)/Makefile
	ln -r -s $(ROOT_MAKE) ./Makefile
else
	$(COPY) $(SRC_MAKES) $(SRC_DIR)
	$(COPY) $(ROOT_MAKES) .
endif
	$(COPY) $(CONFIGS) .

HELP += \n\n**all**: install files, packages
.PHONY: all
all: install-files install-packages global-link
	echo all
.DEFAULT_GOAL :=all

