#######################################
# BOOTSTRAP
#######################################

#Try to figure out where we are in a npm package

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
#  FILES and DIRECS
######################################

#XXX dont add trailing '/' to paths
FILES_SRC := $(shell find . -name '*.js')
TARGETS := $(FILES_SRC:%.js=%.out)
DIFFS := $(FILES_SRC:%.js=%.diff)

####################################
# RULES
####################################

####################################
# all
HELP +=\n\n**all**: write diff files (hopefully zero length) comparing old node output to new
.PHONY: all force
all: $(DIFFS)

.PHONY: force
force: ;

####################################
# clean
HELP +=\n\n**clean**: Remove `TARGETS` and diffs.
.PHONY: clean
clean:
	rm -f $(TARGETS) $(DIFFS)
######################################
# INCLUDE
######################################

include $(DIR_MAKEJS)/lib/test.makefile
include $(DIR_MAKEJS)/lib/common.makefile
.DEFAULT_GOAL := all

######################################
# YOUR RULES and OVERIDES
######################################

