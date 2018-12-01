######################################
#  Files / Direcs
######################################

ifeq ($(BASE_DIR),)
$(error BASE_DIR is undefined)
endif

IDX_GRON  := $(BASE_DIR)/template/index.gron #stores timestamps, etc..
EXCL_FILE := $(BASE_DIR)/.cdn_libs #libs listed here wont be built in bundle or vendor (for cdn)
PACKAGE_LOCK := $(BASE_DIR)/package-lock.json

VENDOR_BASENAME ?=vendor
BUNDLE_BASENAME ?=bundle
CSS_BASENAME ?=main
BUILD_DIR ?=./build
SRC_DIR ?=./
DEP_FILE ?= $(BUILD_DIR)/.deps #node_modules deps

######################################
#  Find files
######################################

ifeq (strip($(EXCL_SRC_DIRS)),)
	_EXC = 
else
	_EXC =  -not \( $(patsubst %,-path % -prune -o,$(EXCL_SRC_DIRS)) -path $(BUILD_DIR) -prune \)
endif
SRC_FILES := $(shell find $(SRC_DIR) $(_EXC) -name '*.js')
ES5_FILES := $(patsubst $(SRC_DIR)%.js,$(BUILD_DIR)/%.es5.js,$(SRC_FILES))
CSS_FILES := $(shell find $(SRC_DIR) $(_EXC) -name '*.css')
BUILD_TARGETS = $(patsubst $(TARGET_DIR)%,$(BUILD_DIR)%,$(TARGETS))

######################################
#  Commands
######################################

# put in your options you need here
#
BABEL_OPTIONS := --presets=es2015# --plugins transform-react-jsx --plugins transform-class-properties
# LINTER_OPTIONS := --parser babel-eslint --plugin react --plugin import
#
# for using cdn libs
# BROWSERIFY_OPTIONS := --transform browserify-global-shim 
#
# umd bundles
# BROWSERIFY_OPTIONS := '-s Bundle'

# gzip is probably installed, sudo apt-get install gzip
GZIP := gzip $(GZIP_OPTIONS)

# https://github.com/tomnomnom/gron/releases:  precompiled binary for linux
# Gron is written in Go so its also pre-compiled
# but you can compile it yourself if you want.
GRON := $(BASE_DIR)/bin/gron

# these should be installed globally (npm -g install `da-package`) from npm
BABEL := babel $(BABEL_OPTIONS)
BROWSERIFY := browserify $(BROWSERIFY_OPTIONS)
UGLIFYJS := uglifyjs $(UGLIFYJS_OPTIONS)
LINTER := echo #eslint $(ESLINT_OPTIONS)
 
######################################
# Shell Commands / Macros
######################################

# strips library paths to import names
# 		          remove root       ignore local stuff       remove node_modules    first direc
STRIP_DEPS := sed "s:^`cd .. && pwd`/::" |grep  "^node_modules" | sed "s:^node_modules::" | cut -d "/" -f2 |sort |uniq
#removes libraries found in exclude file
ONLY_INCLUDE = cat $(EXCL_FILE) | cut -d' ' -f1 | grep -v -f - $(DEP_FILE)
#$(info  debug: ONLY_INCLUDE: $(shell $(ONLY_INCLUDE)))

#browiserify flags to exclude
EXC_DEPS = $(shell cat $(DEP_FILE) | sed 's/ / -x /g' | sed 's/^/ -x /')

#browiserify flags to force inclusion
INC_DEPS = echo $(shell $(ONLY_INCLUDE)) | sed 's/ / -r /g' | sed 's/^/ -r /'

set_template_val = $(shell sed -i '/^json\.$(1)/d' $(IDX_GRON) ;\
				   echo json.$(1) = "$(2)"\; >> $(IDX_GRON))

set_timestamp = $(call set_template_val,ts_$(1),$(shell date +%s))

make_script_link = \<script href=\"$(1)\"\>\</script\>

# pulls last record 
get_dev_cdns = $(foreach href,$(shell cut -d'	' -f2-3 $(EXCL_FILE) | awk 'NF>0{print $$NF}'),\
			   $(call make_script_link,$(href)))

# pulls first record
get_prod_cdns = $(foreach href,$(shell cut -d'	' -f2 $(EXCL_FILE)),\
			   $(call make_script_link,$(href)))

#http://www.tero.co.uk/scripts/minify.php
minify_css := sed -e "s|/\*\(\\\\\)\?\*/|/~\1~/|g" \
	-e "s|/\*[^*]*\*\+\([^/][^*]*\*\+\)*/||g" \
	-e "s|\([^:/]\)//.*$$|\1|" \
	-e "s|^//.*$$||" | tr '\n' ' ' | \
	sed -e "s|/\*[^*]*\*\+\([^/][^*]*\*\+\)*/||g" \
	-e "s|/\~\(\\\\\)\?\~/|/*\1*/|g" \
	-e "s|\s\+| |g" \
	-e "s| \([{;:,]\)|\1|g" \
	-e "s|\([{;:,]\) |\1|g" 

# this one fails but they look almost the same
#https://github.com/CMDann/CSSJSMinify
#-e "s|/*[^]*+([^/][^]*+)/||g"  
	####	-e "s|([^:/])//.$$|\1|" \
	####	-e "s|^//.$$||" \
	####	| tr '\n' ' ' \
	####	| sed -e "s|/*[^]*+([^/][^]*+)/||g" \
	####	-e "s|/~(\\)?~/|/\1/|g"  \
	####	-e "s|\s+| |g" \
	####	-e "s| ([{;:,])|\1|g" \
	####	-e "s|([{;:,]) |\1|g"
