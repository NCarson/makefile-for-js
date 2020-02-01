# For Production Mode aka NODE_ENV=production (minified)
# run `PRODUCTION=1 make`

# For Development
# run `make`

MJS_HELP +=\nrun `make -j 8` to run with 8 threads (set the number to number of cores)! \
		   \nrun `make -n` for a dry run that will print out the actually commands it would have used \
		   \nrun `make --debug=b` basic debug dependency chain \
		   \nrun `make -f PROJECT_ROOT/makefiles-for-js/makefiles/js.makefile -p` to print out rules of the js makefile \
		   \n

######################################
#  Knobs
######################################
#XXX dont set bool type variables to zero. 

#    BAD: USE_THINGY :=0
#	 GOOD: USE_THINGY :=
#
#	 This is because make usually checks for existance of variable being set.
#
#XXX  watch out with spaces when setting variables
#	  make is very literal in setting things
#
#     BAD: BASE_DIR := .. # will evaluate to ' .. '
#     GOOD: BASE_DIR :=..# will evaluate to '..'

#     So the value starts right after assingment symbol and ends
#     at newline or comment hash.

#XXX  debug tips
#	  inline: $(info |$(BASE_DIR)|) #pipes help show spaces
#	  command line: `make print-BASE_DIR`

USE_BABEL :=1 #babel (needs global install)

USE_LINTER :=1 #eslint (needs global install)

# set for easier debugging in web console
USE_SOURCEMAPS :=1

# set for react options on babel and eslint
# you  still need to install babel transforms locally
REACT :=1

# set for latest syntax like spread op and static classes
# you still need to install babel transforms locally
POST_ES6 :=1

######################################
#  Direcs and files
######################################

#XXX dont add trailing '/' to paths
BASE_DIR :=..
SRC_DIR :=.
BUILD_DIR :=$(SRC_DIR)/build

######################################
#  Package build
#
VENDOR_BASENAME :=vendor# this will be the name of vendor bundle in TARGET_DIR
BUNDLE_BASENAME :=bundle# this will be the name of your source bundle TARGET_DIR
TARGET_DIR :=$(BASE_DIR)/public/dist# finished files go here

# set this for ignored directories in your source direc
# EXCL_SRC_DIRS :=./leave_me_alone ./and_me

# Set this if you have a local node module
# in another directory i.e. npm install --save ../my/local/node_module/.
# This will will rebuild the bundle every time these dependencies change.
#
#LOCAL_NODE_FILES =

#XXX make sure to define ungzipped version along 
#    with gzipped so `make clean` works correctly.
BUNDLE_TARGET := \
	$(TARGET_DIR)/$(BUNDLE_BASENAME).min.js \
	$(TARGET_DIR)/$(BUNDLE_BASENAME).min.js.gz

VENDOR_TARGET := \
	$(TARGET_DIR)/$(VENDOR_BASENAME).min.js \
	$(TARGET_DIR)/$(VENDOR_BASENAME).min.js.gz

# this it what make will try try to build
TARGETS :=  $(BUNDLE_TARGET) $(VENDOR_TARGET)

######################################
#  UMD libary build

#TARGET_DIR :=$(BASE_DIR)/lib# finished files go here
#UMD_BASENAME :=umd#XXX this needs to be different from the source file names
#TARGETS := \
#    $(TARGET_DIR)/$(UMD_BASENAME).js \
#    $(TARGET_DIR)/$(UMD_BASENAME).min.js \
#    $(TARGET_DIR)/$(UMD_BASENAME).min.js.gz \ # all components bundled
#    $(TARGET_DIR)/PostgrestFetcher.js \ # for individual imports
#	 $(TARGET_DIR)/PostgrestQuery.js # etc ...
#
#    find all source files (on default export per file) and append ../lib direc to them
#    TARGETS  := $(shell find . -path ./build -prune -o -name '*.js' -print | awk '{print "../lib/" $$0}')
#	 TARGETS += $(patsubst %.js,%.min.js,$(TARGETS))# minified
#	 TARGETS += $(patsubst %.js,%.min.js.gz,$(TARGETS))# gzipped

#FIXME find the find command to pull out targets
######################################
# Includes / Default Rules
######################################

####################################
# Rules

.PHONY: all
all: $(TARGETS)
MJS_HELP +=\nall: make all the targets

.PHONY: clean
clean:
	rm -f $(TARGETS)
	rm -fr $(BUILD_DIR)
MJS_HELP +=\nclean: remove targets and build direc

####################################
# Includes
#
MAKE_DIR:=$(BASE_DIR)/makefile-for-js/makefiles/
include $(MAKE_DIR)/common.makefile
# you may want to take a peek at this also
# as it contains other variables that can be changed.
include $(MAKE_DIR)/js.makefile 

####################################
# Custom programs (have to go after includes)
#
#LINTER := #set your own linter
#BABEL := #set your own transpiler
#see js.makefile for more

######################################
# Your rules
######################################
# XXX define your own rules AFTER the includes
# 	  otherwise you will overwrite the default
# 	  rule, aka `make all` without arguments.


