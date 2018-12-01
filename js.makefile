
# can not get this to work ):
# check-defined = $(ifeq $(value $1),,$(error "$1" $($1) is not defined))

ifeq ($(BASE_DIR),)
$(error BASE_DIR is undefined)
endif
ifeq ($(TARGET_DIR),)
$(error TARGET_DIR is undefined)
endif
ifeq ($(TARGETS),)
$(error TARGETS is undefined)
endif

include $(BASE_DIR)/conf.makefile

######################################
#  Phonies
######################################

.PHONY: all phobia dep-file vendor-libs all-libs

all: $(BUILD_DIR) $(IDX_GRON) $(TARGETS)

phobia:
	cat $(DEP_FILE)
	cat $(DEP_FILE) | xargs -L1 bundle-phobia

dep-file: $(BUILD_DIR) $(ES5_FILES)
	@$(BROWSERIFY) --list $(ES5_FILES) | $(STRIP_DEPS) > $(DEP_FILE) 

#debug variable: `make print-MYVAR`
print-%:
	@echo '$*=$($*)'

######################################
#  Rules
######################################

#jq does not like empty files, so give it an object
$(IDX_GRON): 
	echo > "json = {};"

$(TARGETS): $(BUILD_TARGETS)
	cp $(patsubst $(TARGET_DIR)%,$(BUILD_DIR)%,$@) $@

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

#make will delete these as 'intermediate' without this
.PRECIOUS: $(BUILD_DIR)/%.min.js 

#minify
$(BUILD_DIR)/%.min.js: $(BUILD_DIR)/%.js
ifdef PRODUCTION
	$(UGLIFYJS) -cmo $@ $<
else
	cp $< $@ #were pretending to uglify since were in dev mode
endif

#bundle
$(BUILD_DIR)/$(BUNDLE_BASENAME).js: $(ES5_FILES) $(DEP_FILE)
	$(BROWSERIFY) -o $@ $(EXC_DEPS) $(ES5_FILES) 
	$(shell $(call set_timestamp,$(BUNDLE_BASENAME)))

#vendor
$(BUILD_DIR)/$(VENDOR_BASENAME).js: $(ES5_FILES) $(DEP_FILE)
	$(BROWSERIFY) -o $@ $(shell $(INC_DEPS))
	$(call set_timestamp,$(VENDOR_BASENAME))

#write dependicies
$(DEP_FILE): $(PACKAGE_LOCK)
	$(BROWSERIFY) --list $(ES5_FILES) | $(STRIP_DEPS) > $(DEP_FILE) 

#babel
$(BUILD_DIR)/%.es5.js: $(SRC_DIR)/%.js
	$(LINTER) $<
	$(BABEL) $< --out-file $@ 

%.gz: %
	$(GZIP) $< --stdout > $@

#minify css
$(BUILD_DIR)/%.min.css: $(BUILD_DIR)/%.css
	# minify css
	@ cat $< | $(minify_css) > $@

#cat css into one file
$(BUILD_DIR)/$(CSS_BASENAME).css: $(CSS_FILES)
	# cat $(CSS_FILES)
	@ echo "/* XXX	Auto Generated; modifications will be OVERWRITTEN; see js.makefile XXX */" > $@
	@ for name in $(CSS_FILES); do printf "\n/* $$name */" >>$@ ; cat $$name >> $@; done;

#nunjucks template
$(BUILD_DIR)/%.html: %.m4
	$(shell cat $(IDX_M4) $< | m4 > $@
