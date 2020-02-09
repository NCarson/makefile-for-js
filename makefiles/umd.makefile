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
DIR_EXCL_SRC :=
# Set this if you have a local node module
# in another directory i.e. npm install --save ../my/local/node_module/.
# This will will rebuild the bundle every time these dependencies change.
DIR_LOCAL_DEPS :=

#######################################
#  UMD LIBRARY BUILD
 
DIR_TARGET := $(DIR_PRJ_ROOT)/lib# library type
UMD_BASENAME :=umd# XXX this needs to be different from the source file names #FIXME does it??
TARGETS := $(DIR_TARGET)/$(UMD_BASENAME).js

#TARGETS := \
#    $(DIR_TARGET)/$(UMD_BASENAME).js \
#    $(DIR_TARGET)/$(UMD_BASENAME).min.js \
#    $(DIR_TARGET)/$(UMD_BASENAME).min.js.gz \ # all components bundled
#    $(DIR_TARGET)/PostgrestFetcher.js \ # for individual imports
#	 $(DIR_TARGET)/PostgrestQuery.js # etc ...
#
#    find all source files (on default export per file) and append ../lib direc to them
#    leave out index as that probably goes in PROJECT_ROOT
#TARGETS := $(shell find . -path $(DIR_BUILD) -prune -o -name '*.js' -print \
#	| grep -v ^./index.js$ \
#	| cut -b1-2 --complement \
#	| awk '{print "$(DIR_TARGET)/"$$0}'  \
#	)
#	 TARGETS += $(patsubst %.js,%.min.js,$(TARGETS))# minified
#    TARGETS += $(patsubst %.js,%.min.js.gz,$(TARGETS))# gzipped
#    TARGETS += ../index.js# an index that imports all targets

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
#
