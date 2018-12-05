
# production mode aka NODE_ENV=production
# will produce minified versions
# run `PRODCUTION=1 make`

# development
# run `make`

######################################
#  Direcs and files
######################################

# XXX leading direcs './' ARE IMPORTANT
BASE_DIR := ../
VENDOR_BASENAME := vendor
BUNDLE_BASENAME := bundle
CSS_BASENAME := main
TARGET_DIR := $(BASE_DIR)/public/dist

# XXX these are main targets to build
# aka $(BUNDLE_BASENAME).js would build unminifed and un-gzipped
# remove them if you dont want to build them
TARGETS :=  \
	$(TARGET_DIR)/$(BUNDLE_BASENAME).min.js \
  	$(TARGET_DIR)/$(BUNDLE_BASENAME).min.js.gz \
  	$(TARGET_DIR)/$(VENDOR_BASENAME).min.js.gz \
	$(TARGET_DIR)/$(VENDOR_BASENAME).min.js \
	$(TARGET_DIR)/$(CSS_BASENAME).min.css \
	$(TARGET_DIR)/$(CSS_BASENAME).min.css.gz \

EXCL_SRC_DIRS := ./codesplit ./umd

include $(BASE_DIR)/.js.makefile

# XXX define your own rules AFTER the include
# otherwise you will over write the default
# rule, aka `make` without arguments.

clean:
	rm -f $(TARGETS)
	rm -fr $(BUILD_DIR)

