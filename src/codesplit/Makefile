
# production mode aka NODE_ENV=production
# will produce minified versions
# run `PRODCUTION=1 make`

# development
# run `make`

######################################
#  Direcs and files
######################################

# XXX leading direcs './' ARE IMPORTANT
BASE_DIR := ../../
BUNDLE_BASENAME := codesplit
CSS_BASENAME := codesplit
TARGET_DIR := $(BASE_DIR)/public/dist

# XXX these are main targets to build
# aka $(BUNDLE_BASENAME).js would build unminifed and un-gzipped
# remove them if you dont want to build them
TARGETS := $(TARGET_DIR)/$(BUNDLE_BASENAME).min.js \
		   $(TARGET_DIR)/$(BUNDLE_BASENAME).min.js.gz \
		   $(TARGET_DIR)/$(CSS_BASENAME).min.css \
		   $(TARGET_DIR)/$(CSS_BASENAME).min.css.gz \

include $(BASE_DIR)/js.makefile

clean:
	rm -f $(TARGETS)
	rm -fr $(BUILD_DIR)

