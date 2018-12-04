
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

include $(BASE_DIR)/.conf.makefile

######################################
#  Find files
######################################

es5_to_js = $(basename $(basename $1)).js
js_to_es5 = $(basename $1).es5.js
BUILD_CONFIG = $(patsubst $(SRC_DIR)%,$(BUILD_DIR)%,$(SRC_CONFIG))

# switch out dev or prod config if necessary
ifneq ($(realpath $(CONFIG)),$(shell realpath $(SRC_CONFIG)))
$(info $(call _info_msg,config - link,$(CONFIG),$(GREEN)))
$(shell test -f $(SRC_CONFIG) && rm -f $(SRC_CONFIG))
$(shell test -d $(BUILD_DIR) && touch $(BUILD_CONFIG))
$(shell ln -s $(CONFIG) $(SRC_CONFIG))
endif

ifeq (strip($(EXCL_SRC_DIRS)),)
	_EXC = 
else
	_EXC =  -not \( $(patsubst %,-path % -prune -o,$(EXCL_SRC_DIRS)) -path $(BUILD_DIR) -prune \)
endif
SRC_FILES = $(shell find $(SRC_DIR) $(_EXC) -name '*.js') 
ES5_FILES = $(patsubst $(SRC_DIR)%.js,$(BUILD_DIR)/%.js,$(SRC_FILES))
CSS_FILES = $(shell find $(SRC_DIR) $(_EXC) -name '*.css')
BUILD_TARGETS = $(patsubst $(TARGET_DIR)%,$(BUILD_DIR)%,$(TARGETS))

######################################
#  Phonies
######################################

.PHONY: all

all: $(BUILD_DIR) $(IDX_JSON) $(TARGETS)

phobia:
	@cat $(DEP_FILE)
	@cat $(DEP_FILE) | xargs -L1 $(BUNDLE-PHOBIA)

######################################
#  Rules
######################################

$(IDX_JSON): 
	@echo "{}" > $(IDX_JSON)

$(TARGET_DIR)%: $(BUILD_DIR)%
	@$(call info_msg,target - cp,$@,$(CYAN))
	@cp $(patsubst $(TARGET_DIR)%,$(BUILD_DIR)%,$@) $@

$(BUILD_DIR):
	@mkdir $(BUILD_DIR)

$(PACKAGE_LOCK):
	@touch $(PACKAGE_LOCK)

#make will delete these as 'intermediate' without this
.PRECIOUS: $(BUILD_DIR)/%.min.js 

#minfy
$(BUILD_DIR)/%.min.js: $(BUILD_DIR)/%.js
ifdef PRODUCTION
	@$(call info_msg,uglify - minify (prod/on),$@,$(BLUE))
	@$(UGLIFYJS) -cmo $@ $<
else
	@$(call info_msg,uglify - minify (dev/off),$@,$(GRAY))
	@cp $< $@ #were pretending to uglify since were in dev mode
endif

#umd
$(BUILD_DIR)/$(UMD_BASENAME).js: $(SRC_CONFIG) $(ES5_FILES) $(DEP_FILE)
	@$(call info_msg,browerisfy - umd,$@,$(BOLD)$(MAGENTA))
	@$(BROWSERIFY) -s $(UMD_BASENAME) -o $@ $(EXC_DEPS) $(ES5_FILES) 

get_deps = $(shell cat $(DEP_FILE) | tr '\n' ' ')
#vendor
$(BUILD_DIR)/$(VENDOR_BASENAME).js: $(DEP_FILE)
	$(call info_msg,browerisfy - depends,$(call get_deps),$(YELLOW))
	@$(call info_msg,browerisfy - vendor,$@,$(BOLD)$(MAGENTA))
	@$(BROWSERIFY) -o $@ $(shell $(INC_DEPS))
	$(shell $(call set_timestamp,$(VENDOR_BASENAME)))


#write dependicies
$(DEP_FILE): $(PACKAGE_LOCK)
	@$(BROWSERIFY) --list $(ES5_FILES) | $(STRIP_DEPS) > $(DEP_FILE) 

#bundle
$(BUILD_DIR)/$(BUNDLE_BASENAME).js: $(SRC_CONFIG) $(ES5_FILES) $(DEP_FILE)
	@$(call info_msg,browerisfy - bundle,$@,$(BOLD)$(MAGENTA))
	@$(BROWSERIFY) -o $@ $(EXC_DEPS) $(ES5_FILES) 
	@$(call set_timestamp,$(BUNDLE_BASENAME))

#@echo $(shell /bin/echo -e "babel: transpile: $(GREEN)$<$(NOCOLOR)")
#babel
$(BUILD_DIR)/%.js: %.js 
ifneq ($(LINTER),)
	$(LINTER) $<
endif
ifneq ($(BABEL),)
	@$(call info_msg,babel - transplile,$@,$(BOLD)$(GREEN))
	@$(BABEL) $< --out-file $@ 
else
	@cp $< $@
endif

# config
$(SRC_CONFIG): $(CONFIG)
	@rm -f $@
	@ln -s $(shell realpath $<) $@
	@$(call info_msg,config - link,$@,$(GREEN))

#minify css
$(BUILD_DIR)/%.min.css: $(BUILD_DIR)/%.css
ifdef PRODUCTION
	@$(call info_msg,css - minify (prod/on),$<,$(BLUE))
	@ cat $< | $(minify_css) > $@
else
	@$(call info_msg,css - minify (dev/off),$<,$(GRAY))
	@ cp $< $@
endif

#cat css into one file
$(BUILD_DIR)/$(CSS_BASENAME).css: $(CSS_FILES)
	@$(call info_msg,css - cat,$<,$(BOLD)$(GREEN))
	@ echo "/* XXX	Auto Generated; modifications will be OVERWRITTEN; see js.makefile XXX */" > $@
	@ for name in $(CSS_FILES); do printf "\n/* $$name */" >>$@ ; cat $$name >> $@; done;

#template
$(BUILD_DIR)/%.html: %.json %$(TEMPLATE_SFX)
ifneq ($(TEMPLATER),)
	@$(call info_msg,template - make,$(addsuffix $(TEMPLATE_SFX),$(basename $<)),$(BOLD)$(GREEN))
	@$(TEMPLATER) $< $(addsuffix $(TEMPLATE_SFX),$(basename $<)) > $@ 
else
	$(error no TEMPLATER program has been set)
endif


