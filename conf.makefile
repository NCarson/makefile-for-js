#XXX this should not contain any non-pattern rules as it
#	 is read first and will will wipe out the
#	 first default 'all' rule.

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
SRC_CONFIG ?= $(BASE_DIR)/config.js
REPOS_NAME ?= node_modules

BUILD_CONFIG := $(patsubst $(BASE_DIR)%,$(BUILD_DIR)%,$(SRC_CONFIG))

#expose config*.js to the search path
vpath %.js $(BASE_DIR)
vpath $(BUILD_DIR)

######################################
#  Find files
######################################
es5_to_js = $(basename $(basename $1)).js
js_to_es5 = $(basename $1).es5.js

ifeq (strip($(EXCL_SRC_DIRS)),)
	_EXC = 
else
	_EXC =  -not \( $(patsubst %,-path % -prune -o,$(EXCL_SRC_DIRS)) -path $(BUILD_DIR) -prune \)
endif
SRC_FILES = $(shell find $(SRC_DIR) $(_EXC) -name '*.js')
ES5_FILES = $(patsubst $(SRC_DIR)%.js,$(BUILD_DIR)/%.js,$(SRC_FILES)) $(BUILD_DIR)/config.js
CSS_FILES = $(shell find $(SRC_DIR) $(_EXC) -name '*.css')
BUILD_TARGETS = $(patsubst $(TARGET_DIR)%,$(BUILD_DIR)%,$(TARGETS))

######################################
#  Commands
######################################

# put in your options you need here
#
BABEL_OPTIONS ?= --presets=es2015# --plugins transform-react-jsx --plugins transform-class-properties
# LINTER_OPTIONS := --parser babel-eslint --plugin react --plugin import
#
# for using cdn libs
BROWSERIFY_OPTIONS := --transform browserify-global-shim 
#
# umd bundles
# BROWSERIFY_OPTIONS := '-s Bundle'

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
#LINTER := eslint $(ESLINT_OPTIONS)

# optional for templating
JSON ?= json
TEMPLATER ?= mustache
TEMPLATE_SFX ?= .mustache

#optional for phobia rule
BUNDLE-PHOBIA ?= bundle-phobia # npm i -g babel-cli
 
######################################
# Shell Commands / Macros
######################################

# strips library paths to import names
# 		          remove root       ignore local stuff       remove node_modules    first direc
STRIP_DEPS ?= sed "s:^`cd $(BASE_DIR) && pwd`/::" |grep  "^$(REPOS_NAME)" | sed "s:^$(REPOS_NAME)::" | cut -d "/" -f2 |sort |uniq
#removes libraries found in exclude file
ONLY_INCLUDE = cat $(EXCL_FILE) | cut -d' ' -f1 | grep -v -f - $(DEP_FILE)
#$(info  debug: ONLY_INCLUDE: $(shell $(ONLY_INCLUDE)))

#browiserify flags to exclude
EXC_DEPS = $(shell cat $(DEP_FILE) | sed 's/ / -x /g' | sed 's/^/ -x /')

#browiserify flags to force inclusion
INC_DEPS = echo $(shell $(ONLY_INCLUDE)) | sed 's/ / -r /g' | sed 's/^/ -r /'


ifneq ($(JSON),)
set_template_val = $(JSON) -I -f $(IDX_JSON) -e 'this.$(1)="$(2)"'
endif

set_timestamp = $(call set_template_val,ts_$(1),$(shell date +%s))

make_script_link = <script type=\"text/javascript\" src=\"$(1)\"></script>

# pulls last record 
get_dev_cdns = $(foreach href,$(shell cut -d'	' -f2-3 $(EXCL_FILE) | awk 'NF>0{print $$NF}'),\
			   $(call make_script_link,$(href)))

# pulls first record
get_prod_cdns = $(foreach href,$(shell cut -d'	' -f2 $(EXCL_FILE)),\
			   $(call make_script_link,$(href)))

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
# Pattern Rules
######################################

#XXX pattern rules aka `targets with %` will not wipe out default

#gzipped
%.gz: %
	$(GZIP) $< --stdout > $@
