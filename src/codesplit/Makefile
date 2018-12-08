

######################################
#  Direcs and files
######################################

# XXX leading direcs './' ARE IMPORTANT
BASE_DIR := ../../
BUNDLE_BASENAME := codesplit
TARGET_DIR := $(BASE_DIR)/public/dist

# XXX these are main targets to build
# aka $(BUNDLE_BASENAME).js would build unminifed and un-gzipped
# remove them if you dont want to build them
TARGETS := $(TARGET_DIR)/$(BUNDLE_BASENAME).min.js \
		   $(TARGET_DIR)/$(BUNDLE_BASENAME).min.js.gz \

######################################
#  Overide settings for directory
######################################
# we dont need to transpile so why waste time
LINTER :=
BABEL :=
include $(BASE_DIR)/.conf.makefile
