#XXX this should not contain any non-pattern rules as it
#	 is read first and will will wipe out the
#	 first default 'all' rule.
 
# BASE_DIR defines the root of the of the project.
# It is always required to be defined in the parent.
ifeq ($(BASE_DIR),)
$(error BASE_DIR is undefined)
endif

# wipe out built in C stuff
MAKEFLAGS += --no-builtin-rules
SUFFIXES :=

######################################
#  Commands
######################################

# put in your options you need here
# ?= means they will set if they have not already
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
LINTER ?= eslint $(ESLINT_OPTIONS) #npm i -g eslint

# optional for templating
JSON ?= json
TEMPLATER ?= mustache
TEMPLATE_SFX ?= .mustache

#optional for phobia rule
BUNDLE-PHOBIA ?= bundle-phobia # npm i -g bundle-phobia
 
######################################
#  Files / Direcs
######################################

GZ_SUFFIXES = .html .svg .css

BUILD_DIR ?= ./build
SRC_DIR ?= ./
TEMPLATE_DIR ?= $(BASE_DIR)/template
STATIC_DIR ?= $(BASE_DIR)/public

VENDOR_BASENAME ?= vendor
BUNDLE_BASENAME ?= bundle
UMD_BASENAME ?= umd
CSS_BASENAME ?= main

## config

SRC_CONFIG ?= $(SRC_DIR)config.js
CONFIG_PROD ?= $(BASE_DIR)/config.prod.js
CONFIG_DEV ?= $(BASE_DIR)/config.dev.js
ifdef PRODUCTION
CONFIG ?= $(CONFIG_PROD)
export PRODUCTION
else
CONFIG ?= $(CONFIG_DEV)
endif

## package management

DEP_SUFFIX ?= .deps
DEP_FILE ?= $(BUILD_DIR)/.$(VENDOR_BASENAME)$(DEP_SUFFIX) # keeps track of what modules the bundle is using
PACKAGE_LOCK ?= $(BASE_DIR)/package-lock.json # the npm package-lock
MODULES_NAME ?= node_modules# npm direc name

## templating

EXCL_SUFFIX ?= .cdn.json
EXCL_FILE ?= $(BASE_DIR)/.exclude$(EXCL_SUFFIX) # libs listed here wont be built in bundle or vendor (for cdn)

IDX_JSON ?= index.json # stores bundle info for templating
IDX_JSON_FILE ?= $(TEMPLATE_DIR)/$(IDX_JSON)
IDX_HTML_FILE ?= $(STATIC_DIR)/index.html

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



