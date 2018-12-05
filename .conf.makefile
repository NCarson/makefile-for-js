#XXX this should not contain any non-pattern rules as it
#	 is read first and will will wipe out the
#	 first default 'all' rule.

######################################
#  Commands
######################################

# put in your options you need here
#
BABEL_OPTIONS ?= --presets=es2015 --source-maps=inline
# react and post ES6
# BABEL_OPTIONS := --presets=es2015,react --plugins transform-react-jsx,transform-object-rest-spread,transform-class-properties 
# add source maps in devolpment
ifndef PRODUCTION
	BABEL_OPTIONS += --source-maps=inline
endif

# LINTER_OPTIONS := --parser babel-eslint --plugin react --plugin import
#
# for using cdn libs
BROWSERIFY_OPTIONS := --transform browserify-global-shim 
# add source maps in devolpment
ifndef PRODUCTION
	BROWSERIFY_OPTIONS += -d
endif

# gzip is probably installed, sudo apt-get install gzip
GZIP ?= gzip $(GZIP_OPTIONS)

# XXX These should be installed globally (npm -g install `da-package`) from npm.

# browserify is the only mainstream bundler that behaves well
# on the command line. Very necessary
BROWSERIFY ?= browserify $(BROWSERIFY_OPTIONS)

# You dont need uglifyjs is dont specify min.js or min.js.gz targets.
UGLIFYJS ?= uglifyjs $(UGLIFYJS_OPTIONS)

# you dont have to use babel but browserify will expect es5
BABEL ?= babel $(BABEL_OPTIONS) # npm i -g babel-cli #not babel
# optional linter
#LINTER := eslint $(ESLINT_OPTIONS) #npm i -g eslint

# optional for templating
JSON ?= json
TEMPLATER ?= mustache
TEMPLATE_SFX ?= .mustache

#optional for phobia rule
BUNDLE-PHOBIA ?= bundle-phobia # npm i -g bundle-phobia
 
######################################
#  Files / Direcs
######################################

# BASE_DIR defines the root of the of the project.
# It is always required to be defined in the parent.
ifeq ($(BASE_DIR),)
$(error BASE_DIR is undefined)
endif

# ?= means they will set if they have not already

# IDX_JSON is part of the dependency tree.
# It stores timestamps and cdn lib information.
# If you do not use templating you can set it to 
# a dot file so you do not clutter the directory.
IDX_JSON ?= $(BASE_DIR)/template/index.json 
EXCL_FILE ?= $(BASE_DIR)/.cdn_libs #libs listed here wont be built in bundle or vendor (for cdn)
PACKAGE_LOCK ?= $(BASE_DIR)/package-lock.json #the npm package-lock
CONFIG_PROD ?= $(BASE_DIR)/config.prod.js
CONFIG_DEV ?= $(BASE_DIR)/config.dev.js
ifdef PRODUCTION
CONFIG ?= $(CONFIG_PROD)
export PRODUCTION
else
CONFIG ?= $(CONFIG_DEV)
endif

# default names
VENDOR_BASENAME ?=vendor
BUNDLE_BASENAME ?=bundle
UMD_BASENAME ?=umd
CSS_BASENAME ?=main
BUILD_DIR ?=./build
SRC_DIR ?=./
STATIC_DIR ?= $(BASE_DIR)/public
DEP_FILE ?= $(BUILD_DIR)/.deps #node_modules deps
SRC_CONFIG ?= $(SRC_DIR)/config.js
REPOS_NAME ?= node_modules

######################################
# Shell Commands / Macros
######################################

NORMAL=$(shell tput sgr0)
BLACK=$(shell tput setaf 0)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
BLUE=$(shell tput setaf 4)
MAGENTA=$(shell tput setaf 5)
CYAN=$(shell tput setaf 6)
WHITE=$(shell tput setaf 7)
GRAY=$(shell tput setaf 8)

BOLD=$(shell tput bold)
BLINK=$(shell tput blink)
REVERSE=$(shell tput smso)
UNDERLINE=$(shell tput smul)


_info_msg = $(shell printf "%-25s $(3)$(2)$(NORMAL)\n" "$(1)")

define info_msg 
	@printf "%-25s $(3)$(2)$(NORMAL)\n" "$(1)"
endef

# strips library paths to import names
# 		          remove root       ignore local stuff       remove node_modules    first direc
STRIP_DEPS ?= sed "s:^`cd $(BASE_DIR) && pwd`/::" |grep  "^$(REPOS_NAME)" | sed "s:^$(REPOS_NAME)::" | cut -d "/" -f2 |sort |uniq

#browiserify flags to exclude
EXC_DEPS = $(shell cat $(DEP_FILE) | sed 's/ / -x /g' | sed 's/^/ -x /')

#removes libraries found in exclude file
ONLY_INCLUDE = cat $(EXCL_FILE) | cut -d' ' -f1 | grep -v -f - $(DEP_FILE)
#browiserify flags to force inclusion
INC_DEPS = $(shell $(ONLY_INCLUDE) | sed 's/ / -r /g' | sed 's/^/ -r /')

ifneq ($(JSON),)
set_template_val = $(JSON) -I -f $(IDX_JSON) -e 'this.$(1)="$(2)"' 2>/dev/null
endif

set_timestamp = $(call set_template_val,ts_$(1),$(shell date +%s))

make_script_link = <script type=\"text/javascript\" src=\"$(1)\"></script>


#http://www.tero.co.uk/scripts/minify.php
minify_css ?= sed -e "s|/\*\(\\\\\)\?\*/|/~\1~/|g" \
	-e "s|/\*[^*]*\*\+\([^/][^*]*\*\+\)*/||g" \
	-e "s|\([^:/]\)//.*$$|\1|" \
	-e "s|^//.*$$||" | tr '\n' ' ' | \
	sed -e "s|/\*[^*]*\*\+\([^/][^*]*\*\+\)*/||g" \
	-e "s|/\~\(\\\\\)\?\~/|/*\1*/|g" \
	-e "s|\s\+| |g" \
	-e "s| \([{;:,]\)|\1|g" \
	-e "s|\([{;:,]\) |\1|g" 

######################################
#  Find files
######################################

es5_to_js = $(basename $(basename $1)).js
js_to_es5 = $(basename $1).es5.js
BUILD_CONFIG = $(patsubst $(SRC_DIR)%,$(BUILD_DIR)%,$(SRC_CONFIG))

# switch out dev or prod config if necessary
ifneq ($(realpath $(CONFIG)),$(shell realpath $(SRC_CONFIG)))
$(info $(call _info_msg,config - link,$(CONFIG),$(GREEN)))
$(shell test -f $(SRC_CONFIG) && rm -f $(SRC_CONFIG))
# We have to nuke BUILD_DIR (at least *.js) since are sourcemap flags are diferent.
$(shell rm -fr $(BUILD_DIR))
$(shell ln -s $(CONFIG) $(SRC_CONFIG))
endif

ifeq (strip($(EXCL_SRC_DIRS)),)
	_EXC = 
else
	_EXC =  -not \( $(patsubst %,-path % -prune -o,$(EXCL_SRC_DIRS)) -path $(BUILD_DIR) -prune \)
endif
SRC_FILES = $(shell find $(SRC_DIR) $(_EXC) -name '*.js') 
ES5_FILES = $(patsubst $(SRC_DIR)%.js,$(BUILD_DIR)/%.js,$(SRC_FILES))
CSS_FILES = $(shell find $(SRC_DIR) $(_EXC) -name '*.css')
BUILD_TARGETS = $(patsubst $(TARGET_DIR)%,$(BUILD_DIR)%,$(TARGETS))

######################################
# Pattern Rules
######################################

#XXX pattern rules aka `targets with %` will not wipe out default

######################################
# Debug

#debug variable: `make print-MYVAR`
print-%:
	@echo '$*=$($*)'

######################################
# Targets

$(TARGET_DIR)%: $(BUILD_DIR)%
	@$(call info_msg,target - cp,$@,$(CYAN))
	@cp $(patsubst $(TARGET_DIR)%,$(BUILD_DIR)%,$@) $@

######################################
# CSS

#minify css
%.min.css: %.css
ifdef PRODUCTION
	@$(call info_msg,css - minify (prod/on),$@,$(BLUE))
	@ cat $< | $(minify_css) > $@
else
	@$(call info_msg,css - minify (dev/off),$@,$(GRAY))
	@ cp $< $@
endif

#cat css into one file
%/$(CSS_BASENAME).css: $(CSS_FILES)
	@$(call info_msg,css - cat,$^,$(BOLD)$(GREEN))
	@ echo "/* XXX	Auto Generated; modifications will be OVERWRITTEN; see js.makefile XXX */" > $@
	@ for name in $(CSS_FILES); do printf "\n/* $$name */" >>$@ ; cat $$name >> $@; done;

######################################
# Template

#template
%.html: %.json %$(TEMPLATE_SFX)
ifneq ($(TEMPLATER),)
	@$(call info_msg,template - make,$(addsuffix $(TEMPLATE_SFX),$(basename $<)),$(BOLD)$(GREEN))
	@$(TEMPLATER) $< $(addsuffix $(TEMPLATE_SFX),$(basename $<)) > $@ 
else
	$(error no TEMPLATER program has been set)
endif

######################################
# Bundle
#

#minfy
%.min.js: %.js
ifdef PRODUCTION
	@$(call info_msg,uglify - minify (prod/on),$@,$(BLUE))
	@$(UGLIFYJS) -cmo $@ $<
else
	@$(call info_msg,uglify - minify (dev/off),$@,$(GRAY))
	@cp $< $@ #were pretending to uglify since were in dev mode
endif

#make will delete these as 'intermediate' without this
.PRECIOUS: %/$(UMD_BASENAME).js
#umd
%/$(UMD_BASENAME).js: $(SRC_CONFIG) $(ES5_FILES) $(DEP_FILE)
	@$(call info_msg,browerisfy - umd,$@ $(EXC_DEPS),$(BOLD)$(MAGENTA))
	@$(BROWSERIFY) -s $(UMD_BASENAME) -o $@ $(EXC_DEPS) $(ES5_FILES) 
	$(shell $(call set_timestamp,$(UMD_BASENAME)))

.PRECIOUS: %/$(VENDOR_BASENAME).js
#vendor
%/$(VENDOR_BASENAME).js: $(DEP_FILE)
	@$(call info_msg,browerisfy - vendor,$@ $(INC_DEPS),$(BOLD)$(MAGENTA))
	@$(BROWSERIFY) -o $@ $(INC_DEPS)
	$(shell $(call set_timestamp,$(VENDOR_BASENAME)))


.PRECIOUS: %/$(BUNDLE_BASENAME).js
#bundle
%/$(BUNDLE_BASENAME).js: $(DEP_FILE) $(SRC_CONFIG) $(ES5_FILES)
	@$(call info_msg,browerisfy - bundle,$@ $(EXC_DEPS),$(BOLD)$(MAGENTA))
	@$(BROWSERIFY) -o $@ $(EXC_DEPS) $(ES5_FILES) 
	@$(call set_timestamp,$(BUNDLE_BASENAME))

######################################
# Transpile

#babel
$(BUILD_DIR)/%.js: %.js 
ifneq ($(LINTER),)
	$(LINTER) $<
endif
ifneq ($(BABEL),)
	@$(call info_msg,babel - transplile,$@,$(BOLD)$(GREEN))
	@$(BABEL) $< --out-file $@ 
else
	@cp $< $@
endif

######################################
# Util

#gzipped
%.gz: %
	@$(call info_msg,gizp - compress,$@,$(BLUE))
	@$(GZIP) $< --stdout > $@
