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

ifeq ($(NODE_ENV),production)
PRODUCTION := 1
endif

######################################
#  Knobs
######################################

# set for react options on babel and eslint
# you  still need to install babel transforms locally
# REACT := 1

# set for latest syntax like spread op and static classes
# you  still need to install babel transforms locally
# POST_ES6 := 1

######################################
#  Commands
######################################

# XXX put in your options you need here
# ?= means you can overide from command line
# like: `BABEL_OPTIONS="my special options" make`

# XXX Npm packages should be installed globally 
# (suo npm -g install `da-package`).

######################################
#  Babel
 
ifdef REACT
BABEL_OPTIONS += --presets=es2015,react --plugins transform-react-jsx
else
BABEL_OPTIONS += --presets=es2015
endif

# add source maps in devolpment
ifndef PRODUCTION
BABEL_OPTIONS += --source-maps=inline
endif

# latest ES features
ifdef POST_ES6 
BABEL_OPTIONS += transform-object-rest-spread,transform-class-properties 
endif

# you dont have to use babel but browserify will expect es5
# npm i -g babel-cli #not babel
BABEL ?= babel $(BABEL_OPTIONS) 

######################################
#  Browserify

# for using cdn libs
BROWSERIFY_OPTIONS ?= --transform browserify-global-shim 
# add source maps in devolpment
ifndef PRODUCTION
	BROWSERIFY_OPTIONS += -d
endif

# browserify is the only mainstream bundler that behaves well
# on the command line. Very necessary
BROWSERIFY ?= browserify $(BROWSERIFY_OPTIONS)

######################################
#  Templating
 
# optional for templating
JSON ?= json
TEMPLATER ?= mustache
TEMPLATE_SFX ?= .mustache
 
######################################
#  Others
 
# gzip is probably installed, sudo apt-get install gzip
GZIP ?= gzip $(GZIP_OPTIONS)

# You dont need uglifyjs is dont specify min.js or min.js.gz targets.
UGLIFYJS ?= uglifyjs $(UGLIFYJS_OPTIONS)

# optional linter
LINTER_OPTIONS := --parser babel-eslint --plugin import
ifdef REACT
LINTER_OPTIONS += --plugin react
endif 
#npm i -g eslint
LINTER ?= eslint $(ESLINT_OPTIONS) 

#optional for phobia rule
# npm i -g bundle-phobia
BUNDLE-PHOBIA ?= bundle-phobia 
 
######################################
#  Files / Direcs
######################################

## direcs
BUILD_DIR ?= ./build
SRC_DIR ?= ./
TEMPLATE_DIR ?= $(BASE_DIR)/template
STATIC_DIR ?= $(BASE_DIR)/public

## bundle names
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
IDX_JSON ?= index.json
IDX_JSON_FILE := $(TEMPLATE_DIR)/$(IDX_JSON)

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
