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
# XXX This needs leading directories
DIR_EXCL_SRC := ./node_modules
# Set this if you have a local node module
# in another directory i.e. npm install --save ../my/local/node_module/.
# This will will rebuild the bundle every time these dependencies change.
DIR_LOCAL_DEPS :=

