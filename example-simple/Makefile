#######################################
# MAKEFILE-JS OPTIONS 
#######################################
DIR_PRJ_ROOT :=..
USE_REACT :=
USE_BABEL :=1
USE_LINTER :=
USE_SOURCE_MAPS :=1
USE_POST_ES6 :=

#######################################
# BOOTSTRAP
#######################################

DIR_PRJ_ROOT ?= .
#######################################
# DIR_MAKEJS
# find out if we are in dev mode or using this as a npm package
# :( make 4.1 does not have .SHELLSTATUS
_PACKAGE_NAME_S := $(shell npm run env 2>/dev/null 1>/dev/null; echo $$?)
ifneq ($(_PACKAGE_NAME_S),0)
$(error no npm package found in this directory $(CURDIR))
endif

_PACKAGE_NAME := $(shell npm run env | grep ^npm_package_name= | cut -d= -f2)
ifeq ($(_PACKAGE_NAME),makefile-for-js)
DIR_MAKEJS := $(DIR_PRJ_ROOT)
else
DIR_MAKEJS := $(DIR_PRJ_ROOT)/node_modules/makefile-for-js
endif

ifndef DIR_MAKEJS
$(error could not find makefile-for-js)
endif

######################################
# KNOBS
######################################

######################################
#  FILES and DIRECS
######################################

#XXX dont add trailing '/' to paths
DIR_SRC := .
DIR_BUILD := $(DIR_SRC)/build
# set this for ignored directories in your source direc
#XXX This needs leading directories
DIR_EXCL_SRC := ./public
# Set this if you have a local node module
# in another directory i.e. npm install --save ../my/local/node_module/.
# This will will rebuild the bundle every time these dependencies change.
DIR_LOCAL_DEPS :=

#######################################
#  PACKAGE BUILD

DIR_TARGET := public/dist# finished files go here
VENDOR_BASENAME :=vendor# this will be the name of vendor bundle in DIR_TARGET
BUNDLE_BASENAME :=bundle# this will be the name of your source bundle DIR_TARGET

#XXX make sure to define ungzipped version along 
#    with gzipped so `make clean` works correctly.
BUNDLE_TARGET := \
	$(DIR_TARGET)/$(BUNDLE_BASENAME).min.js \
	$(DIR_TARGET)/$(BUNDLE_BASENAME).min.js.gz

VENDOR_TARGET := \
	$(DIR_TARGET)/$(VENDOR_BASENAME).min.js \
	$(DIR_TARGET)/$(VENDOR_BASENAME).min.js.gz

# this it what make will try try to build
TARGETS :=  $(BUNDLE_TARGET) $(VENDOR_TARGET)

####################################
# RULES
####################################

HELP +=\n\n**all**: Make the `TARGETS`.
.PHONY: all
all: $(TARGETS)
.DEFAULT_GOAL := all

HELP +=\n\n**clean**: Remove `TARGETS` and `DIR_BUILD`.
.PHONY: clean
clean:
	rm -f $(TARGETS)
	rm -fr $(DIR_BUILD)

######################################
# INCLUDES
######################################

include $(DIR_MAKEJS)/lib/js.makefile 
include $(DIR_MAKEJS)/lib/common.makefile

######################################
# YOUR RULES and OVERIDES
######################################

# overide variables and rules here so you will overwrite
# the include makefiles instead of the other way around

