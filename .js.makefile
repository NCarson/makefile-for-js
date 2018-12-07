
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

_info_msg = $(shell printf "%-25s $(3)$(2)$(NORMAL)\n" "$(1)")
define info_msg 
	@printf "%-25s $(3)$(2)$(NORMAL)\n" "$(1)"
endef

######################################
#  Find files
######################################

# switch out dev or prod config if necessary
ifneq ($(realpath $(CONFIG)),$(shell realpath $(SRC_CONFIG)))
$(info $(call _info_msg,config - link,$(CONFIG),$(GREEN)))
$(shell test -f $(SRC_CONFIG) && rm -f $(SRC_CONFIG))
$(shell rm -f $(SRC_CONFIG))
$(shell ln -s $(CONFIG) $(SRC_CONFIG))
$(shell touch $(SRC_CONFIG))
# We have to nuke BUILD_DIR (at least *.js) since the sourcemap flags are diferent.
#$(shell rm -fr $(BUILD_DIR))
endif

ifeq (strip($(EXCL_SRC_DIRS)),)
	_EXC = 
else
	_EXC =  -not \( $(patsubst %,-path % -prune -o,$(EXCL_SRC_DIRS)) -path $(BUILD_DIR) -prune \)
endif
SRC_FILES = $(shell find $(SRC_DIR) $(_EXC) -name '*.js')  $(SRC_CONFIG)
ES5_FILES = $(patsubst $(SRC_DIR)%.js,$(BUILD_DIR)/%.js,$(SRC_FILES))
CSS_FILES = $(shell find $(SRC_DIR) $(_EXC) -name '*.css')
TEMPLATE_FILES = $(shell find $(SRC_DIR) -name '*$(TEMPLATE_SFX)')
TEMPLATE_BUILD_FILES = $(patsubst $(SRC_DIR)%$(TEMPLATE_SFX),$(BUILD_DIR)/%.html,$(TEMPLATE_FILES))

######################################
#  Phonies
######################################

.PHONY: all phobia

all: $(SRC_CONFIG) $(TARGETS)

phobia: $(DEP_FILE)
	@cat $(DEP_FILE)
	@cat $(DEP_FILE) | xargs -L1 $(BUNDLE-PHOBIA)

######################################
#  Rules
######################################

$(PACKAGE_LOCK):
	$(call info_message,touch - create,$@)
	@touch $(PACKAGE_LOCK)

#XXX pattern rules aka `targets with %` will not wipe out default

######################################
# Debug

#debug variable: `make print-MYVAR`
print-%:
	@ echo '$*=$($*)'
#https://blog.melski.net/2010/11/30/makefile-hacks-print-the-value-of-any-variable/

######################################
# Targets

$(TARGET_DIR)%: $(BUILD_DIR)%
	@ $(call info_msg,target - cp,$@,$(WHITE))
	@ cp $(patsubst $(TARGET_DIR)%,$(BUILD_DIR)%,$@) $@

######################################
# Template
 
ifneq ($(JSON),) #JSON

# list library names
#
# make sure we output something or ONLY_INCLUDE will not work

mfs_excluded_libs = $(JSON) -f $(EXCL_FILE) -a name

# set timestamps
define set_template_val
	@ test -f $(IDX_JSON_FILE) || echo "{}" > $(IDX_JSON_FILE)
	@ $(JSON) -I -f $(IDX_JSON_FILE) -e 'this.$(1)="$(2)"' 2>/dev/null
endef

set_timestamp = $(call set_template_val,ts_$(1),$(shell date +%s))

#list cdn hrefs
mfs_cdn_dev = $(shell $(JSON) -f $(EXCL_FILE) -a -e 'this.href=this.dev || this.prod'  -a href | tr '\n' ' ')
mfs_cdn_prod  = $(JSON) -f $(EXCL_FILE) -a -e 'this.href=this.prod'  -a href | tr '\n' ' '


make_script_link = <script type=\"text/javascript\" src=\"$(1)\"></script>\n
# pulls last record 
get_dev_cdns = $(foreach href,\
			   $(mfs_cdn_dev),\
			   $(call make_script_link,$(href)))

# pulls first record
get_prod_cdns = $(foreach href,\
				$(shell $(mfs_cdn_prod)),\
			    $(call make_script_link,$(href)))

$(EXCL_FILE):
	@ $(call info_msg,json - create,$@,$(BOLD))
	@ echo "[]" > $@

# Updates cdn in index.json info when EXCL_FILES changes.
%$(IDX_JSON): $(EXCL_FILE)
	@ $(call info_msg,cdn - update,$@,$(WHITE))
	@ test -f $@ || echo "{}" > $@
# Sometimes npm's dont have development builds so just use prod
# if thats all there is.
ifdef PRODUCTION
	@ $(call set_template_val,cdns,$(call get_prod_cdns))
else
	@ $(call set_template_val,cdns,$(call get_dev_cdns))
endif

.PRECIOUS: $(BUILD_DIR)/%.html
#template
$(BUILD_DIR)/%.html: %.json %$(TEMPLATE_SFX)
ifneq ($(TEMPLATER),)
	@ mkdir -p $(BUILD_DIR)
	$(call info_msg,template - create,$@,$(BOLD))
	@$(TEMPLATER) $< $(addsuffix $(TEMPLATE_SFX),$(basename $<)) > $@ 
else
	$(error no TEMPLATER program has been set)
endif

$(COMPRESS_FILES_GZ) : $(COMPRESS_FILES)
	@ $(call info_msg,gizp - compress,$@,$(BLUE))
	@ $(GZIP) $< --stdout > $@

else #JSON
mfs_excluded_libs = echo " "
endif #JSON

######################################
# CSS
 
#http://www.tero.co.uk/scripts/minify.php
minify_css ?= sed -e "s|/\*\(\\\\\)\?\*/|/~\1~/|g" \
	-e "s|/\*[^*]*\*\+\([^/][^*]*\*\+\)*/||g" \
	-e "s|\([^:/]\)//.*$$|\1|" \
	-e "s|^//.*$$||" | tr '\n' ' ' | \
	sed -e "s|/\*[^*]*\*\+\([^/][^*]*\*\+\)*/||g" \
	-e "s|/\~\(\\\\\)\?\~/|/*\1*/|g" \
	-e "s|\s\+| |g" \
	-e "s| \([{;:,]\)|\1|g" \
	-e "s|\([{;:,]\) |\1|g" 

#make will delete these as 'intermediate' without this
.PRECIOUS: %.min.css
#minify css
%.min.css: %.css
ifdef PRODUCTION
	@ mkdir -p $(BUILD_DIR)
	@ $(call info_msg,css - minify (prod/on),$@,$(BLUE))
	@ cat $< | $(minify_css) > $@
else
	@ mkdir -p $(BUILD_DIR)
	@ $(call info_msg,css - minify (dev/off),$@,$(GRAY))
	@ cp $< $@
endif

.PRECIOUS: %/$(CSS_BASENAME).css
#cat css into one file
%/$(CSS_BASENAME).css: $(CSS_FILES)
	@ mkdir -p $(BUILD_DIR)
	@ $(call info_msg,css - cat,$^,$(BOLD)$(YELLOW))
	@ echo "/* XXX	Auto Generated; modifications will be OVERWRITTEN; see js.makefile XXX */" > $@
	@ for name in $(CSS_FILES); do printf "\n/* $$name */" >>$@ ; cat $$name >> $@; done;


######################################
# Bundle

# strips library paths to import names
# 		          remove root       ignore local stuff       remove node_modules    first direc
STRIP_DEPS ?= \
	sed "s:^`cd $(BASE_DIR) && pwd`/::" |\
	grep  "^$(strip $(MODULES_NAME))" |\
	sed "s:^$(strip $(MODULES_NAME))::" |\
	cut -d "/" -f2 |sort |uniq

#browiserify flags to force exclusion
EXC_DEPS = $(shell cat $(DEP_FILE) | sed 's/ / -x /g' | sed 's/^/ -x /')
#removes libraries found in exclude file
ONLY_INCLUDE = $(mfs_excluded_libs) | cut -d" " -f1 | grep -v -f - $(DEP_FILE)
#browiserify flags to force inclusion
INC_DEPS = $(shell $(ONLY_INCLUDE) | sed 's/ / -r /g' | sed 's/^/ -r /')

# find deps
#
# notice order-only prereq: | 
# ES5_FILES will only be a prereq if PACKAGE_LOCK is old.
# Otherwise vendor would be dependent on ES5_FILES and always be rebuilt.
%$(DEP_SUFFIX): $(EXCL_FILE) $(PACKAGE_LOCK) | $(ES5_FILES)
	@$(call info_msg,browserify - find deps,$@,$(MAGENTA))
	@$(BROWSERIFY) --list $(ES5_FILES) | $(STRIP_DEPS) > $@

.PRECIOUS: %.min.js
#minfy
%.min.js: %.js
ifdef PRODUCTION
	@ mkdir -p $(BUILD_DIR)
	@ $(call info_msg,uglify - minify (prod/on),$@,$(BLUE))
	@ $(UGLIFYJS) -cmo $@ $<
else
	@ $(call info_msg,uglify - minify (dev/off),$@,$(GRAY))
	@ cp $< $@ #were pretending to uglify since were in dev mode
endif

#test -f $@ || echo "{}" > $@
define mjs_make_bundle
	@ mkdir -p $(BUILD_DIR)
	@ $(call info_msg,browerisfy - $1,$2 $3,$(BOLD)$(MAGENTA))
	@ $(BROWSERIFY) $5 -o $2 $(ES5_FILES) $(3)
	@ $(call set_timestamp,$4)
endef

.PRECIOUS: %/$(UMD_BASENAME).js
#umd
%/$(UMD_BASENAME).js: $(ES5_FILES) $(DEP_FILE)
	$(call mjs_make_bundle,umd,$@,$(EXC_DEPS),$(UMD_BASENAME),-s $(UMD_BASENAME))

.PRECIOUS: %/$(VENDOR_BASENAME).js
#vendor
%/$(VENDOR_BASENAME).js: $(DEP_FILE)
	$(call mjs_make_bundle,vendor,$@,$(INC_DEPS),$(VENDOR_BASENAME))

.PRECIOUS: %/$(BUNDLE_BASENAME).js
#bundle
%/$(BUNDLE_BASENAME).js: $(DEP_FILE) $(ES5_FILES)
	$(call mjs_make_bundle,bundle,$@,$(EXC_DEPS),$(BUNDLE_BASENAME))

######################################
# Transpile

.PRECIOUS: $(BUILD_DIR)/%.js
#babel
$(BUILD_DIR)/%.js: %.js 
	@ mkdir -p $(BUILD_DIR)
ifneq ($(LINTER),)
	@ $(call info_msg,eslint - lint,$<,$(GREEN))
	@ $(LINTER) $<
endif
ifneq ($(BABEL),)
	@ $(call info_msg,babel - transplile,$@,$(BOLD)$(GREEN))
	@ $(BABEL) $< --out-file $@ 
else
	@ cp $< $@
endif

######################################
# Util

#gzipped
%.gz: %
	@ $(call info_msg,gizp - compress,$@,$(BLUE))
	@ $(GZIP) $< --stdout > $@

