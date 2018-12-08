
# production mode aka NODE_ENV=production
# will produce minified versions
# run `PRODCUTION=1 make`

# development
# run `make`

######################################
#  Direcs and files
######################################

BASE_DIR := ..
VENDOR_BASENAME := vendor
BUNDLE_BASENAME := bundle
UMD_BASENAME := umd
CSS_BASENAME := main
TARGET_DIR := $(BASE_DIR)/public/dist

#XXX make sure to define ungzipped version along 
#    with gzipped so `make clean` works correctly.
BUNDLE_TARGET := \
	$(TARGET_DIR)/$(BUNDLE_BASENAME).min.js \
	$(TARGET_DIR)/$(BUNDLE_BASENAME).min.js.gz

VENDOR_TARGET := \
	$(TARGET_DIR)/$(VENDOR_BASENAME).min.js \
	$(TARGET_DIR)/$(VENDOR_BASENAME).min.js.gz

UMD_TARGET := \
	$(TARGET_DIR)/$(UMD_BASENAME).min.js \
	$(TARGET_DIR)/$(UMD_BASENAME).min.js.gz

CSS_TARGET := \
	$(TARGET_DIR)/$(CSS_BASENAME).min.css \
	$(TARGET_DIR)/$(CSS_BASENAME).min.css.gz

# XXX these are main targets to build
# aka $(BUNDLE_BASENAME).js would build unminifed and un-gzipped
# remove them if you dont want to build them
TARGETS :=  $(BUNDLE_TARGET) \
	$(VENDOR_TARGET) \
	$(CSS_TARGET) \
	$(IDX_JSON_FILE) 

EXCL_SRC_DIRS := ./codesplit ./umd

include $(BASE_DIR)/.makefiles/conf.makefile

#  makes a dependency graph with dot
#  https://github.com/lindenb/makefile2graph
dot-graph: $(TARGETS)
	make -Bnd | make2graph | dot -Tpng -o ../.dot-graph.png


# XXX define your own rules AFTER the include
# otherwise you will over write the default
# rule, aka `make all` without arguments.

