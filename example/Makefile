HELP_FILE += \n\n`src.makefile`\
\n\n\#\#\# JS Source Code Management.\
\nManages bundle builds for javascript files.\
\n\
\nrun `make help` see top level non-pattern rules\
\nrun `make` development\
\nrun `make PRODUCTION=1` production production mode (minified) aka NODE_ENV=production\

######################################
# KNOBS
######################################

######################################
#  FILES and DIRECS
######################################

#XXX dont add trailing '/' to paths
DIR_PRJ_ROOT := ..
DIR_SRC := .
DIR_MAKEJS := $(DIR_PRJ_ROOT)#$(DIR_PRJ_ROOT)/node_modules/makefile-for-js
DIR_BUILD := $(DIR_SRC)/build

# set this for ignored directories in your source direc
DIR_EXCL_SRC := ./public
#
# Set this if you have a local node module
# in another directory i.e. npm install --save ../my/local/node_module/.
# This will will rebuild the bundle every time these dependencies change.
DIR_LOCAL_DEPS :=

######################################
#  COMMANDS
######################################


#######################################
#  PACKAGE BUILD

DIR_TARGET := ./public/dist# finished files go here
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

include $(DIR_MAKEJS)/makefiles/js.makefile 
include $(DIR_MAKEJS)/makefiles/common.makefile

######################################
# YOUR RULES and OVERIDES
######################################

# overide variables and rules here so you will overwrite
# the include makefiles instead of the other way around
