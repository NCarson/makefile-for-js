
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

# switch out dev or prod config if necessary
ifneq ($(realpath $(CONFIG)),$(shell realpath $(SRC_CONFIG)))
$(info removing old config ...)
$(shell test -f $(SRC_CONFIG) && rm -f $(SRC_CONFIG); touch $(BUILD_CONFIG))
endif

######################################
#  Phonies
######################################

.PHONY: all

all: $(BUILD_DIR) $(IDX_JSON) $(TARGETS)

#debug variable: `make print-MYVAR`
print-%:
	@echo '$*=$($*)'

phobia:
	cat $(DEP_FILE)
	cat $(DEP_FILE) | xargs -L1 $(BUNDLE-PHOBIA)

######################################
#  Rules
######################################

$(IDX_JSON): 
	echo "{}" > $(IDX_JSON)

$(TARGET_DIR)%: $(BUILD_DIR)%
	cp $(patsubst $(TARGET_DIR)%,$(BUILD_DIR)%,$@) $@

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(PACKAGE_LOCK):
	touch $(PACKAGE_LOCK)

#make will delete these as 'intermediate' without this
.PRECIOUS: $(BUILD_DIR)/%.min.js 

#minfy
$(BUILD_DIR)/%.min.js: $(BUILD_DIR)/%.js
ifdef PRODUCTION
	$(UGLIFYJS) -cmo $@ $<
else
	cp $< $@ #were pretending to uglify since were in dev mode
endif

#umd
$(BUILD_DIR)/$(UMD_BASENAME).js: $(SRC_CONFIG) $(ES5_FILES) $(DEP_FILE)
	$(BROWSERIFY) -s $(UMD_BASENAME) -o $@ $(EXC_DEPS) $(ES5_FILES) 

#vendor
$(BUILD_DIR)/$(VENDOR_BASENAME).js: $(DEP_FILE)
	$(BROWSERIFY) -o $@ $(shell $(INC_DEPS))
	$(shell $(call set_timestamp,$(VENDOR_BASENAME)))

#write dependicies
$(DEP_FILE): $(PACKAGE_LOCK)
	# browserify: list dependicies
	$(BROWSERIFY) --list $(ES5_FILES) | $(STRIP_DEPS) > $(DEP_FILE) 

#bundle
$(BUILD_DIR)/$(BUNDLE_BASENAME).js: $(SRC_CONFIG) $(ES5_FILES) $(DEP_FILE)
	$(BROWSERIFY) -o $@ $(EXC_DEPS) $(ES5_FILES) 
	$(call set_timestamp,$(BUNDLE_BASENAME))

#babel
# We need es5.js extension for the dependency chain.
# We also need to have .js extension for browserisfy
# to be able to find the file (which is why we soft link).
$(BUILD_DIR)/%.js: %.js 
ifneq ($(LINTER),)
	$(LINTER) $<
endif
ifneq ($(BABEL),)
	$(BABEL) $< --out-file $@ 
else
	cp $< $@
endif
	#export name=$(call es5_to_js,$@); test -f $$name || ln -s `pwd`/$@ $$name

# config
$(SRC_CONFIG): $(CONFIG)
	rm -f $@
	ln -s $(shell realpath $<) $@

#minify css
$(BUILD_DIR)/%.min.css: $(BUILD_DIR)/%.css
	# minify css: $<
	@ cat $< | $(minify_css) > $@

#cat css into one file
$(BUILD_DIR)/$(CSS_BASENAME).css: $(CSS_FILES)
	# cat css files into one: $(CSS_FILES)
	@ echo "/* XXX	Auto Generated; modifications will be OVERWRITTEN; see js.makefile XXX */" > $@
	@ for name in $(CSS_FILES); do printf "\n/* $$name */" >>$@ ; cat $$name >> $@; done;

#template
$(BUILD_DIR)/%.html: %.json %$(TEMPLATE_SFX)
ifneq ($(TEMPLATER),)
	$(TEMPLATER) $< $(addsuffix $(TEMPLATE_SFX),$(basename $<)) > $@ 
else
	$(error no TEMPLATER program has been set)
endif


