HELP_FILE +=\n\#js.makefile\
\n\#\#\#Compiles .js sources through chain of linting, transpiling, bundling, minifing, and zipping.\
\nrun `make -f PROJECT_ROOT/makefiles-for-js/makefiles/js.makefile -p` to print out rules of the js makefile

## DIR_BASE defines the root of the of the project.
## It is always required to be defined in the parent.
#ifeq ($(DIR_BASE),)
#$(error DIR_BASE is undefined)
#endif
#
## directory finished files should go to
#ifeq ($(DIR_TARGET),)
#$(error DIR_TARGET is undefined)
#endif
#
## names of the finished files
#ifeq ($(TARGETS),)
#$(error TARGETS is undefined)
#endif

######################################
#  Knobs
######################################

HELP_USE += \n\#\#\#js.makefile

HELP_USE += \n**USE PRODUCTION**: If set then use production options instead of development.\
\n    Also will be set if NODE_ENV=production in the environment.
NODE_ENV ?=
USE_PRODUCTION :=
ifeq ($(NODE_ENV),production)
	USE_PRODUCTION :=1
endif


HELP_USE += \n\n**USE BABEL**: transpile with babel
USE_BABEL :=1

HELP_USE += \n\n**USE LINTER**: use eslint
USE_LINTER :=1

HELP_USE += \n\n**USE SOURCEMAPS**: bundle source maps for debugging
USE_SOURCEMAPS :=1

HELP_USE += \n\n**USE REACT**: set transform flags for react
USE_REACT :=1

HELP_USE += \n\n**POST US6**: babel transform for static class props and object spreads
USE_POST_ES5 :=1

# for find command; set if you have direcs to skip
ifeq (strip($(DIR_EXCL_SRC)),)
	_MFS_EXCLUDE = 
else
	_MFS_EXCLUDE =  -not \( $(patsubst %,-path % -prune -o,$(DIR_EXCL_SRC)) -path $(DIR_BUILD) -prune \)
endif

######################################
#  COMMANDS
######################################

#needed for pipefail option of bash
SHELL := /bin/bash

CMD_GZIP := gzip

#CMD_JSON := json#<https://github.com/trentm/json> for project details.

# You dont need uglifyjs if you do not specify min.js or min.js.gz targets.
CMD_UGLIFYJS :=npx uglifyjs $(CMD_UGLIFYJS_OPTIONS)

# optional linter
CMD_LINTER_OPTIONS := --parser babel-eslint --plugin import
ifdef USE_REACT
CMD_LINTER_OPTIONS += --plugin react
endif 
CMD_LINTER :=npx eslint $(CMD_LINTER_OPTIONS) 

#optional for phobia rule
CMD_BUNDLE-PHOBIA := npx bundle-phobia/index.js

######################################
#  Babel
#
CMD_BABEL := npx babel
CMD_BABEL_OPTIONS += --presets=@babel/preset-env
# add source maps in devolpment
ifndef USE_PRODUCTION
ifdef USE_SOURCEMAPS
CMD_BABEL_OPTIONS += --source-maps=inline
endif
endif

ifdef USE_REACT
CMD_BABEL_OPTIONS += --presets=@babel/preset-react --plugins @babel/plugin-transform-react-jsx
endif

# latest ES features
ifdef USE_POST_ES5 
CMD_BABEL_OPTIONS += --plugins @babel/plugin-transform-object-assign,@babel/plugin-proposal-class-properties,@babel/plugin-syntax-dynamic-import
endif

######################################
#  Browserify

# for using cdn libs
CMD_BROWSERIFY_OPTIONS := --transform browserify-global-shim 
ifdef USE_SOURCEMAPS
# add source maps in development
ifndef USE_PRODUCTION
CMD_BROWSERIFY_OPTIONS += -d
endif
endif

# browserify is the only mainstream bundler that behaves well
# on the command line. Very necessary
CMD_BROWSERIFY := npx browserify


######################################
#  FILES and DIRECS
######################################

FILES_SRC = $(shell find $(DIR_SRC) $(_MFS_EXCLUDE) -name '*.js')
FILES_ES5 = $(patsubst $(DIR_SRC)%.js,$(DIR_BUILD)%.js,$(FILES_SRC))
FILE_PACKAGE_LOCK :=$(DIR_BASE)/package-lock.json# the npm package-lock
FILE_EXCL := $(DIR_SRC)/exclude.deps# libs listed here wont be built in bundle or vendor (for cdn)
FILE_DEPENDS :=$(DIR_BUILD)/$(VENDOR_BASENAME).deps# keeps track of what modules the bundle is using
DIR_NODE_MODULES := $(DIR_BASE)/node_modules# npm direc name

######################################
#  RULES
######################################

HELP +=\n\#\#\#js.makefile

#######################################
# phobia-cdn
HELP +=\n\n**phobia-cdn**: Show how much space you are saving in excluded libs
.PHONY: phobia-cdn
phobia-cdn: list-cdn
	@ $(mfs_excluded_libs) | xargs -L1 $(BUNDLE-PHOBIA)

#######################################
# list-deps
HELP +=\n\n**list-deps**: Show local dependencies.
.PHONY: list-deps
list-deps:
	@cat $(FILE_DEPENDS)

#######################################
# phobia-deps
HELP +=\n\n**phobia-deps**: List package dependencies from bundle-phobia. \
	\n     "sudo npm i -g bundle-phobia"
.PHONY: phobia-deps
phobia-deps: $(FILE_DEPENDS) list-deps
	@cat $(FILE_DEPENDS) | xargs -L1 $(CMD_BUNDLE-PHOBIA)

#######################################
# dot-graph
HELP +=\n\n**dot-graph**: Create a dependency graph of targets.  \
\n    needs makefile2graph https://github.com/lindenb/makefile2graph)
.PHONY: dot-graph
dot-graph: $(TARGETS) 
	make -Bnd | make2graph | dot -Tsvg -o ../.dot-graph.svg

#######################################
# target dir
# everything is built in the DIR_BUILD and then moved to DIR_TARGET
$(DIR_TARGET)%: $(DIR_BUILD)%
	@ $(call _info_msg,target - cp,$@,$(_WHITE))
	@ mkdir -p $(shell dirname $@)
	@ cp $(patsubst $(DIR_TARGET)%,$(DIR_BUILD)%,$@) $@

######################################
# index.js
# moves index.js out of target dir and into project base
$(DIR_BASE)/index.%: $(DIR_TARGET)/index.%
	@ $(call _info_msg,index.js - mv,$@,$(_WHITE))
	@ mv $< $@

######################################
# gzip
%.gz: %
	@ $(call _info_msg,gizp - compress,$@,$(_BLUE))
	@ $(CMD_GZIP) $< --stdout > $@

######################################
# minfy
%.min.js: %.js
	@ mkdir -p `dirname $@`
ifdef USE_PRODUCTION
	@ $(call _info_msg,uglify - minify (production),$@,$(_BLUE))
	@ $(CMD_UGLIFYJS) -cmo $@ $<
else
	@ $(call _info_msg,uglify - minify (development),$@,$(_GRAY))
	@ cp $< $@ #were pretending to uglify since were in dev mode
endif

######################################
# package-lock.json, exclude.deps
# just makes sure they exists
$(FILE_EXCL) $(FILE_PACKAGE_LOCK):
	@ $(call _info_msg,touch - create,$@,$(_BOLD))
	@ touch $@

######################################
# vendor dep file
# FIXME @ modular libries are broken.
# TODO decide if ES5 files should be regular depend
_SRC_PATH := $(shell pwd)
_NODE_PATH := $(shell cd $(DIR_NODE_MODULES) && pwd)
# notice order-only prereq: | 
# FILES_ES5 will only be a prereq if PACKAGE_LOCK is old.
# Otherwise vendor would be dependent on FILES_ES5 and always be rebuilt.
#
# 1. have browserify find dependencies
# 2. filter out source direc and transform to package name
.DELETE_ON_ERROR:
$(FILE_DEPENDS): $(FILE_EXCL) $(FILE_PACKAGE_LOCK) | $(FILES_ES5)
	@ $(call _info_msg,browserify - find deps,$@,$(_MAGENTA))
	@ mkdir -p $(DIR_BUILD)
	@ set -e; set -o pipefail; $(CMD_BROWSERIFY) --list $(FILES_ES5) \
		| $(DIR_MAKEJS)/scripts/node_deps.py - $(_SRC_PATH) $(_NODE_PATH) > $@ \
		> $@
		
######################################
# bundle helpers
#
define _mjs_make_bundle
	@ mkdir -p `dirname $@`
	@ $(call _info_msg,browerisfy - $1,$2 $3 $4,$(BOLD)$(_MAGENTA))
	@ $(CMD_BROWSERIFY) $(CMD_BROWSERIFY_OPTIONS) $6 -o $2 $3 $4
endef

## browserify flags to force exclusion
_EXCL_DEPENDS = $(shell cat $(FILE_DEPENDS) | sed 's/ / -x /g' | sed 's/^/ -x /')
# 1. remove excluded libs
# 2 add browserify flags for inclusion
_INCL_DEPENDS = $(shell \
	cat $(FILE_DEPENDS) | grep -v -x -f $(FILE_EXCL) \
	| sed 's/ / -r /g' | sed 's/^/ -r /')

######################################
# umd bundle
# we dont need dep file with umd
#.PRECIOUS: %/$(UMD_BASENAME).js
%/$(UMD_BASENAME).js: $(FILES_ES5) 
	$(call _mjs_make_bundle,umd,$@,$(FILES_ES5),$(_EXCL_DEPENDS),$(UMD_BASENAME),-s $(UMD_BASENAME))

######################################
## vendor bundle
#.PRECIOUS: %/$(VENDOR_BASENAME).js
%/$(VENDOR_BASENAME).js: $(FILE_DEPENDS)
	$(call _mjs_make_bundle,vendor,$@,,$(_INCL_DEPENDS),$(VENDOR_BASENAME))

######################################
# source bundle
#.PRECIOUS: %/$(BUNDLE_BASENAME).js
%/$(BUNDLE_BASENAME).js: $(FILE_DEPENDS) $(FILES_ES5) $(DIR_LOCAL_DEPS)
	$(call _mjs_make_bundle,bundle,$@,$(FILES_ES5),$(_EXCL_DEPENDS),$(BUNDLE_BASENAME))

######################################
# transpile - lint and babel
#.PRECIOUS: $(DIR_BUILD)/%.js
$(FILES_ES5): $(DIR_BUILD)/%.js: $(DIR_SRC)/%.js 
	@ mkdir -p `dirname $@`
ifneq ($(USE_LINTER),)
	@ $(call _info_msg,eslint - lint,$<,$(_GREEN))
	@ $(CMD_LINTER) $(DIR_SRC)/$<
endif
ifneq ($(USE_BABEL),)
	@ $(call _info_msg,babel - transplile,$@,$(_BOLD)$(_GREEN))
	@ $(CMD_BABEL) $(CMD_BABEL_OPTIONS) $(DIR_SRC)/$< --out-file $@ 
else
	@ $(call _info_msg,no babel - copy,$<,$(_WHITE))
	@ cp $< $@
endif


