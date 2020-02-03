HELP_FILE +=\n\n**js.makefile**\
\n    compiles .js sources through chain of linting, transpiling, bundling, minifing, and zipping.

# wipe out built in C stuff
MAKEFLAGS += --no-builtin-rules --no-builtin-variables
SUFFIX;ES :=

# BASE_DIR defines the root of the of the project.
# It is always required to be defined in the parent.
ifeq ($(BASE_DIR),)
	$(error BASE_DIR is undefined)
endif

# directory finished files should go to
ifeq ($(TARGET_DIR),)
	$(error TARGET_DIR is undefined)
endif

# names of the finished files
ifeq ($(TARGETS),)
	$(error TARGETS is undefined)
endif

# for find command; set if you have direcs to skip
ifeq (strip($(EXCL_SRC_DIRS)),)
	_MFS_EXCLUDE = 
else
	_MFS_EXCLUDE =  -not \( $(patsubst %,-path % -prune -o,$(EXCL_SRC_DIRS)) -path $(BUILD_DIR) -prune \)
endif

######################################
#  Commands
######################################

CMD_JSON ?= json#<https://github.com/trentm/json> for project details.

# You dont need uglifyjs if you do not specify min.js or min.js.gz targets.
CMD_UGLIFYJS ?=npx uglifyjs $(CMD_UGLIFYJS_OPTIONS)

# optional linter
CMD_LINTER_OPTIONS ?= --parser babel-eslint --plugin import
ifdef REACT
	CMD_LINTER_OPTIONS += --plugin react
endif 
CMD_LINTER ?=npx eslint $(CMD_LINTER_OPTIONS) 

#optional for phobia rule
CMD_BUNDLE-PHOBIA ?= npx bundle-phobia/index.js

######################################
#  Babel
#
# you dont have to use babel but browserify will expect es5ish???
#
# add source maps in devolpment
ifndef PRODUCTION
ifdef USE_SOURCEMAPS
CMD_BABEL_OPTIONS += --source-maps=inline
endif
endif

CMD_BABEL_OPTIONS := --presets=@babel/preset-env

ifdef USE_REACT
CMD_BABEL_REACT_OPTIONS += --presets=@babel/preset-react --plugins @babel/plugin-transform-react-jsx
endif

# latest ES features
ifdef POST_ES6 
CMD_BABEL_OPTIONS += --plugins @babel/plugin-transform-object-assign,@babel/plugin-proposal-class-properties,@babel/plugin-syntax-dynamic-import
endif

CMD_BABEL := npx babel $(CMD_BABEL_OPTIONS) $(CMD_BABEL_REACT_OPTIONS)

######################################
#  Browserify

# for using cdn libs
CMD_BROWSERIFY_OPTIONS ?= --transform browserify-global-shim 
ifdef USE_SOURCEMAPS
# add source maps in development
ifndef PRODUCTION
CMD_BROWSERIFY_OPTIONS += -d
endif
endif

# browserify is the only mainstream bundler that behaves well
# on the command line. Very necessary
CMD_BROWSERIFY ?= npx browserify $(CMD_BROWSERIFY_OPTIONS)


######################################
#  Find files
######################################

SRC_FILES = $(shell find $(SRC_DIR) $(_MFS_EXCLUDE) -name '*.js')
ES5_FILES = $(patsubst $(SRC_DIR)%.js,$(BUILD_DIR)%.js,$(SRC_FILES))

######################################
#  Rules
######################################

######################################
# TARGETS
# everything is built in the BUILD_DIR and then moved to TARGET_DIR
$(TARGET_DIR)%: $(BUILD_DIR)%
	@ $(call info_msg,target - cp,$@,$(_WHITE))
	@ mkdir -p $(shell dirname $@)
	@ cp $(patsubst $(TARGET_DIR)%,$(BUILD_DIR)%,$@) $@

######################################
# gzip
GZIP ?= gzip $(GZIP_OPTIONS)
.PRECIOUS: %.gz
%.gz: %
	@ $(call info_msg,gizp - compress,$@,$(_BLUE))
	@ $(GZIP) $< --stdout > $@

######################################
# index.js
$(BASE_DIR)/index.%: $(TARGET_DIR)/index.%
	@ $(call info_msg,index.js - mv,$@,$(_WHITE))
	@ mv $< $@

######################################
# package.lock
PACKAGE_LOCK ?=$(BASE_DIR)/package-lock.json # the npm package-lock
$(PACKAGE_LOCK):
	$(call info_message,touch - create,$@)
	@ touch $(PACKAGE_LOCK)

######################################
# .exclude.cdn.json : cdn libs to exclude from bundles
EXCL_SUFFIX ?=.cdn.json
EXCL_FILE ?= $(BASE_DIR)/.exclude$(EXCL_SUFFIX) # libs listed here wont be built in bundle or vendor (for cdn)
$(EXCL_FILE):
	@ $(call info_msg,json - create,$@,$(_BOLD))
	@ echo "[]" > $@

######################################
# dep file
DEP_SUFFIX ?=.deps
DEP_FILE ?=$(BUILD_DIR)/.$(VENDOR_BASENAME)$(DEP_SUFFIX) # keeps track of what modules the bundle is using
MODULES_NAME ?=node_modules# npm direc name

## FIXME @ modular libries are broken. (just ignores them for now)
## strips library paths to import names
#remove root, ignore local stuff, remove node_modules, first direc, no modular, 
_STRIP_DEPS := \
	sed "s:^`cd $(BASE_DIR) && pwd`/::" |\
	grep "^$(strip $(MODULES_NAME))" |\
	sed "s:^$(strip $(MODULES_NAME))::" |\
	cut -d "/" -f2 |sort |uniq |\
	grep -v ^@ ||\
	true


# notice order-only prereq: | 
# ES5_FILES will only be a prereq if PACKAGE_LOCK is old.
# Otherwise vendor would be dependent on ES5_FILES and always be rebuilt.
$(DEP_FILE): $(EXCL_FILE) $(PACKAGE_LOCK) | $(ES5_FILES)
	@$(call info_msg,browserify - find deps,$@,$(_MAGENTA))
	@mkdir -p $(BUILD_DIR)
	@$(CMD_BROWSERIFY) --list $(ES5_FILES) | $(_STRIP_DEPS) > $@

######################################
# minfy
.PRECIOUS: %.min.js
%.min.js: %.js
	@ mkdir -p `dirname $@`
ifdef PRODUCTION
	@ $(call info_msg,uglify - minify (production),$@,$(_BLUE))
	@ $(CMD_UGLIFYJS) -cmo $@ $<
else
	@ $(call info_msg,uglify - minify (development),$@,$(_GRAY))
	@ cp $< $@ #were pretending to uglify since were in dev mode
endif

define mjs_make_bundle
	@ mkdir -p `dirname $@`
	@ $(call info_msg,browerisfy - $1,$2 $3 $4,$(BOLD)$(_MAGENTA))
	@ $(CMD_BROWSERIFY) $6 -o $2 $3 $4
	@ $(call set_timestamp,$5)
endef

MFS_EXCLUDED_LIBS = $(JSON) -f $(EXCL_FILE) -a name
## browiserify flags to force exclusion
EXC_DEPS = $(shell cat $(DEP_FILE) | sed 's/ / -x /g' | sed 's/^/ -x /')
## removes libraries found in exclude file
ONLY_INCLUDE = $(MFS_EXCLUDED_LIBS) | grep -Fx -v -f - $(DEP_FILE)
## browiserify flags to force inclusion
INC_DEPS = $(shell $(ONLY_INCLUDE) | sed 's/ / -r /g' | sed 's/^/ -r /')

######################################
# umd bundle
# we dont need dep file with umd
.PRECIOUS: %/$(UMD_BASENAME).js
%/$(UMD_BASENAME).js: $(ES5_FILES) 
	$(call mjs_make_bundle,umd,$@,$(ES5_FILES),$(EXC_DEPS),$(UMD_BASENAME),-s $(UMD_BASENAME))

######################################
## vendor bundle
.PRECIOUS: %/$(VENDOR_BASENAME).js
%/$(VENDOR_BASENAME).js: $(DEP_FILE)
	$(call mjs_make_bundle,vendor,$@,,$(INC_DEPS),$(VENDOR_BASENAME))


######################################
# source bundle
.PRECIOUS: %/$(BUNDLE_BASENAME).js
%/$(BUNDLE_BASENAME).js: $(DEP_FILE) $(ES5_FILES) $(LOCAL_NODE_FILES)
	$(call mjs_make_bundle,bundle,$@,$(ES5_FILES),$(EXC_DEPS),$(BUNDLE_BASENAME))


######################################
# transpile - lint and babel
.PRECIOUS: $(BUILD_DIR)/%.js
$(BUILD_DIR)/%.js: $(SRC_DIR)/%.js 
	@ mkdir -p `dirname $@`
ifneq ($(USE_LINTER),)
	@ $(call info_msg,eslint - lint,$<,$(_GREEN))
	@ $(CMD_LINTER) $(SRC_DIR)/$<
endif
ifneq ($(USE_BABEL),)
	@ $(call info_msg,babel - transplile,$@,$(_BOLD)$(_GREEN))
	@ $(CMD_BABEL) $(SRC_DIR)/$< --out-file $@ 
else
	@ cp $< $@
endif

######################################
# Others
.PHONY: list-deps list-cdn phobia-deps phobia-cdn

#FIXME where is mfs_excluded_libs?
#list-cdn:
#	@ $(mfs_excluded_libs)

#phobia-cdn: list-cdn
#	@ $(mfs_excluded_libs) | xargs -L1 $(BUNDLE-PHOBIA)
 
 HELP +=\n\n**list-deps**: Show local dependencies.
list-deps:
	@cat $(DEP_FILE)

HELP +=\n\n**phobia-deps**: List package dependencies from bundle-phobia. \
\n     "sudo npm i -g bundle-phobia"
phobia-deps: $(DEP_FILE) list-deps
	@cat $(DEP_FILE) | xargs -L1 $(CMD_BUNDLE-PHOBIA)

#  makes a dependency graph with dot (super coolio)
#  https://github.com/lindenb/makefile2graph
HELP +=\n\n**dot-graph**: Create a dependency graph of targets.  \
\n    needs makefile2graph https://github.com/lindenb/makefile2graph)
.PHONY: dot-graph
dot-graph: $(TARGETS) 
	make -Bnd | make2graph | dot -Tsvg -o ../.dot-graph.svg




