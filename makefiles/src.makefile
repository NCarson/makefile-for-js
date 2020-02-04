HELP_FILE += \#src.makefile\
\n\#\#\#JS project mananagment for source code.\
\n\
\nrun `make help` see top level non-pattern rules\
\nrun `make` development\
\nrun `make PRODUCTION=1` production production mode (minified) aka NODE_ENV=production\

######################################
#  DIRECS and FILES
######################################

#XXX dont add trailing '/' to paths
DIR_BASE := ..
DIR_SRC := .
DIR_BUILD := $(DIR_SRC)/build
DIR_MAKEJS:=$(DIR_BASE)/makefile-for-js

# set this for ignored directories in your source direc
DIR_EXCL_SRC :=
#
# Set this if you have a local node module
# in another directory i.e. npm install --save ../my/local/node_module/.
# This will will rebuild the bundle every time these dependencies change.
DIR_LOCAL_DEPS :=

#######################################
#  PACKAGE BUILD
######################################
DIR_TARGET := $(DIR_BASE)/public/dist# finished files go here
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

#######################################
#  UMD LIBRARY BUILD
######################################
#DIR_TARGET := $(DIR_BASE)/lib# library type
#UMD_BASENAME :=umd# XXX this needs to be different from the source file names
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
HELP +=\n\n**all**: Make all the targets.
.PHONY: all
all: $(TARGETS)
.DEFAULT_GOAL := all

HELP +=\n\n**clean**: Remove targets and build direc.
.PHONY: clean
clean:
	rm -f $(TARGETS)
	rm -fr $(DIR_BUILD)

####################################
# INCLUDES
####################################
# make sure you put the files all on one line or there is weird scope issues
# make sure all the base variables are defined before these are run
_DIR_MAKE := $(DIR_MAKEJS)/makefiles
include $(_DIR_MAKE)/js.makefile $(_DIR_MAKE)/common.makefile 

######################################
# YOUR RULES and OVERIDES
######################################

# overide variables and rules here so you will overwrite
# the include makefiles instead of the other way around
#
# USE_REACT := 2


