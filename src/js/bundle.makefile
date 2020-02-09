#######################################
#  PACKAGE BUILD

DIR_TARGET := $(DIR_PRJ_ROOT)/public/dist# finished files go here
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

