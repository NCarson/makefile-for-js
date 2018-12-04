# this has to set before the include
BASE_DIR := ./
# use conf.Makefile instead of js.Makefile since 
# we are going to define are own targets.
include conf.$(MAKE)file

# gzip static assets
COMPRESS_FILES := $(shell find $(STATIC_DIR)/ \
	-name '*.svg' \
	-o -name '*.html' \
	-o -name '*.css')
COMPRESS_FILES_GZ := $(patsubst %,%.gz,$(COMPRESS_FILES))

# in case these actually exist as files `$(MAKE)` would be confused without .PHONY
.PHONY: all clean template code cdn

# The first rule in a $(MAKE)file is the default if you just type `make`.
# Traditionally is called all
all: template static

# rm all build files and start fresh
clean: clean-gz
	cd src && $(MAKE) clean
	cd src/codesplit && $(MAKE) clean
	cd src/umd && $(MAKE) clean
	cd template && $(MAKE) clean

# If a dependency chain breaks and the gz file
# is not being updated, you can scratch your head
# for hours on why your changes are not working.
clean-gz:
	rm -f $(COMPRESS_FILES_GZ) 

# This $(MAKE)s sure all the code is already built before it makes the templates.
template: code $(IDX_JSON)
	cd template && $(MAKE)

# bundle js code
code:
	cd src/umd && $(MAKE)
	cd src/codesplit && $(MAKE)
	cd src && $(MAKE)

# Updates cdn in index.json info when .cdn_libs changes.
$(IDX_JSON): $(EXCL_FILE)
# Sometimes npm's dont have devolpment builds so just use prod
# if thats all there is.
ifdef PRODUCTION
	$(call set_template_val,cdns,$(call get_prod_cdns))
else
	$(call set_template_val,cdns,$(call get_dev_cdns))
endif

# gzip static stuff
static: $(COMPRESS_FILES_GZ)

dep-file: $(BUILD_DIR) $(ES5_FILES)
	@$(BROWSERIFY) --list $(ES5_FILES) | $(STRIP_DEPS) > $(DEP_FILE) 

