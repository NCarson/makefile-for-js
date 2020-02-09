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

#######################################
# FILES and DIRECS
#######################################

#######################################
# RULES
#######################################

#######################################
# all
HELP +=\n\n**all**: runs files and npm-install rules
.DEFAULT_GOAL := all
.PHONY: all
all: files npm-install

#######################################
# clean
HELP +=\n\n**clean**: removes files that were added by 'all' rule using the manifset file in `DIR_CACHE`
.PHONY: clean
clean:
	rm --interactive=once $(_mnf_files) $(FILE_COMMIT) $(FILE_MANIFEST)

