#######################################
# MAKEFILE-JS OPTIONS 
#######################################
DIR_PRJ_ROOT :=../..
USE_REACT :=
USE_BABEL :=1
USE_LINTER :=
USE_SOURCE_MAPS :=1
USE_POST_ES6 :=

#######################################
# BOOTSTRAP
#######################################

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

DIR_SRC := .
DIR_BUILD := $(DIR_SRC)/build
DIR_EXCL_SRC := ./pkg

#######################################
#  UMD LIBRARY BUILD
 
DIR_TARGET := pkg/lib# library type
TARGETS := \
    $(DIR_TARGET)/../index.js \
    $(DIR_TARGET)/Foo.js \
	$(DIR_TARGET)/Bar.js

####################################
# RULES
####################################

HELP +=\n\n**all**: Make the `TARGETS`.
.DEFAULT_GOAL := all
.PHONY: all
all: $(TARGETS)

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

