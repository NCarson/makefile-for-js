# For Production Mode aka NODE_ENV=production (minified)
# run `PRODUCTION=1 make`

# For Development
# run `make`

# run `make -j 8` to run with 8 threads!
# run `make -n` for a dry run that will print out the actually commands it would have used
# run `make -d` for a lot of debug info

######################################
#  Knobs
######################################
#XXX dont set bool type variables to zero. 
#    DONT DO: USE_THINGY=0
#	 DO: USE_THINGY=
#	 this is because make usually checks for existance of variable being set

USE_BABEL:= 1

USE_LINTER:= 1

# set for easier debugging in web console
USE_SOURCEMAPS := 1

# set for react options on babel and eslint
# you  still need to install babel transforms locally
REACT := 1

# set for latest syntax like spread op and static classes
# you still need to install babel transforms locally
POST_ES6 := 1

#turn off linter or set your own
#LINTER :=

#turn off babel or set your own
#BABEL :=

######################################
#  Direcs and files
######################################

MAKE_DIR:= $(BASE_DIR)/makefile-for-js/makefiles/ # library of makefiles for includes
BASE_DIR := .. # root direc of project
SRC_DIR := ./ # src file direc
BUILD_DIR := $(SRC_DIR)/build # intermediate build files
#EXCL_SRC_DIRS := ./leave_me_alone ./and_me # ignore these direcs while building sources

# Set this if you have a local node module
# in another directory i.e. npm install --save ../my/local/node_module/.
# This will will rebuild the bundle every time these dependencies change.
#LOCAL_NODE_FILES =

######################################
#  Package build
VENDOR_BASENAME := vendor # this will be the name of vendor bundle in TARGET_DIR
BUNDLE_BASENAME := bundle # this will be the name of your source bundle TARGET_DIR
TARGET_DIR := $(BASE_DIR)/public/dist  #finished files go here

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

#TARGET_DIR := $(BASE_DIR)/lib  #finished files go here

#UMD_BASENAME := umd
#UMD_TARGET := \
#	$(TARGET_DIR)/$(UMD_BASENAME).min.js \
#	$(TARGET_DIR)/$(UMD_BASENAME).min.js.gz
#
# hand library targets
#TARGETS := \
#    $(TARGET_DIR)/../dist/$(UMD_BASENAME).js \
#    $(TARGET_DIR)/../dist/$(UMD_BASENAME).min.js \
#    $(TARGET_DIR)/../dist/$(UMD_BASENAME).min.js.gz \ # all components bundled
#    $(TARGET_DIR)/PostgrestFetcher.js \ # for individual imports
#	 $(TARGET_DIR)/PostgrestQuery.js # etc ...
#
# auto per file library targets
#TARGETS  += $(shell find . -path ./build -prune -o -name '*.js' -print | awk '{print "../lib/" $$0}')

######################################
# Includes / Default Rules
######################################

.PHONY: all
all: $(TARGETS)

.PHONY: clean
clean:
	rm -f $(TARGETS)
	rm -fr $(BUILD_DIR) # dont put things you love in BUILD_DIR

include $(MAKE_DIR)/common.makefile
# you may want to take a peek at this also
# as it contains other variables that can be changed from here.
include $(MAKE_DIR)/js.makefile 

#  makes a dependency graph with dot (super coolio)
#  install dot and https://github.com/lindenb/makefile2graph
.PHONY: dot-graph
dot-graph: $(TARGETS) 
	make -Bnd | make2graph | dot -Tsvg -o ../.dot-graph.svg

# XXX define your own rules AFTER the includes
# otherwise you will overwrite the default
# rule, aka `make all` without arguments.

######################################
# Your rules
######################################


