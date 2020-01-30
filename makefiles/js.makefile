######################################
#  Commands
######################################
######################################
#  Babel
#
# you dont have to use babel but browserify will expect es5

ifdef REACT
	BABEL_OPTIONS += --presets=es2015,react --plugins transform-react-jsx
else
	BABEL_OPTIONS += --presets=es2015
endif

# add source maps in devolpment
ifndef PRODUCTION
	BABEL_OPTIONS += --source-maps=inline
endif

# latest ES features
ifdef POST_ES6 
	BABEL_OPTIONS += --plugins transform-object-rest-spread,transform-class-properties 
endif

BABEL ?= babel
BABEL += $(BABEL_OPTIONS) 

######################################
#  Browserify

# for using cdn libs
BROWSERIFY_OPTIONS ?= --transform browserify-global-shim 
ifdef USE_SOURCEMAPS
	# add source maps in development
	ifndef PRODUCTION
	BROWSERIFY_OPTIONS += -d
endif
endif

# browserify is the only mainstream bundler that behaves well
# on the command line. Very necessary
BROWSERIFY ?= browserify
BROWSERIFY += $(BROWSERIFY_OPTIONS)

######################################
#  Others

# You dont need uglifyjs if you do not specify min.js or min.js.gz targets.
UGLIFYJS ?= uglifyjs $(UGLIFYJS_OPTIONS)

# optional linter
LINTER_OPTIONS ?= --parser babel-eslint --plugin import
ifdef REACT
	LINTER_OPTIONS += --plugin react
endif 
#npm i -g eslint
LINTER ?= eslint $(LINTER_OPTIONS) 

#optional for phobia rule
# npm i -g bundle-phobia
BUNDLE-PHOBIA ?= bundle-phobia 

######################################
#  Find files
######################################

SRC_FILES = $(shell find $(SRC_DIR) $(_MFS_EXCLUDE) -name '*.js')
ES5_FILES = $(patsubst $(SRC_DIR)%.js,$(BUILD_DIR)/%.js,$(SRC_FILES))

######################################
#  Rules
######################################

######################################
# in case package lock does not exist
#
PACKAGE_LOCK ?= $(BASE_DIR)/package-lock.json # the npm package-lock
$(PACKAGE_LOCK):
	$(call info_message,touch - create,$@)
	@ touch $(PACKAGE_LOCK)


######################################
# cdn libs to exclude from bundles

EXCL_SUFFIX ?= .cdn.json
EXCL_FILE ?= $(BASE_DIR)/.exclude$(EXCL_SUFFIX) # libs listed here wont be built in bundle or vendor (for cdn)
$(EXCL_FILE):
	@ $(call info_msg,json - create,$@,$(BOLD))
	@ echo "[]" > $@

######################################
# keeps track of vendor stuff that
# should only be rebuild if npm has updated
 
DEP_SUFFIX ?= .deps
DEP_FILE ?= $(BUILD_DIR)/.$(VENDOR_BASENAME)$(DEP_SUFFIX) # keeps track of what modules the bundle is using
MODULES_NAME ?= node_modules# npm direc name
## strips library paths to import names
# 		          remove root       ignore local stuff       remove node_modules    first direc
STRIP_DEPS ?= \
	sed "s:^`cd $(BASE_DIR) && pwd`/::" |\
	grep "^$(strip $(MODULES_NAME))" |\
	sed "s:^$(strip $(MODULES_NAME))::" |\
	cut -d "/" -f2 |sort |uniq

# notice order-only prereq: | 
# ES5_FILES will only be a prereq if PACKAGE_LOCK is old.
# Otherwise vendor would be dependent on ES5_FILES and always be rebuilt.
%$(DEP_SUFFIX): $(EXCL_FILE) $(PACKAGE_LOCK) | $(ES5_FILES)
	@$(call info_msg,browserify - find deps,$@,$(MAGENTA))
	@$(BROWSERIFY) --list $(ES5_FILES) | $(STRIP_DEPS) > $@

######################################
# minfy
.PRECIOUS: %.min.js
%.min.js: %.js
	@ mkdir -p `dirname $@`
ifdef PRODUCTION
	@ $(call info_msg,uglify - minify (prod/on),$@,$(BLUE))
	@ $(UGLIFYJS) -cmo $@ $<
else
	@ $(call info_msg,uglify - minify (dev/off),$@,$(GRAY))
	@ cp $< $@ #were pretending to uglify since were in dev mode
endif

define mjs_make_bundle
	@ mkdir -p `dirname $@`
	@ $(call info_msg,browerisfy - $1,$2 $3 $4,$(BOLD)$(MAGENTA))
	@ $(BROWSERIFY) $6 -o $2 $3 $4
	@ $(call set_timestamp,$5)
endef

MFS_EXCLUDED_LIBS = $(JSON) -f $(EXCL_FILE) -a name
## browiserify flags to force exclusion
EXC_DEPS = $(shell cat $(DEP_FILE) | sed 's/ / -x /g' | sed 's/^/ -x /')
## removes libraries found in exclude file
ONLY_INCLUDE = $(MFS_EXCLUDED_LIBS) | grep -Fx -v -f - $(DEP_FILE)
## browiserify flags to force inclusion
INC_DEPS = $(shell $(ONLY_INCLUDE) | sed 's/ / -r /g' | sed 's/^/ -r /')

######################################
## umd bundle
.PRECIOUS: %/$(UMD_BASENAME).js
%/$(UMD_BASENAME).js: $(ES5_FILES) $(DEP_FILE)
	$(call mjs_make_bundle,umd,$@,$(ES5_FILES),$(EXC_DEPS),$(UMD_BASENAME),-s $(UMD_BASENAME))

######################################
## vendor bundle
.PRECIOUS: %/$(VENDOR_BASENAME).js
%/$(VENDOR_BASENAME).js: $(DEP_FILE)
	$(call mjs_make_bundle,vendor,$@,,$(INC_DEPS),$(VENDOR_BASENAME))

######################################
## source bundle
.PRECIOUS: %/$(BUNDLE_BASENAME).js
%/$(BUNDLE_BASENAME).js: $(DEP_FILE) $(ES5_FILES) $(LOCAL_NODE_FILES)
	$(call mjs_make_bundle,bundle,$@,$(ES5_FILES),$(EXC_DEPS),$(BUNDLE_BASENAME))

######################################
## transpile
.PRECIOUS: $(BUILD_DIR)/%.js
## lint and babel
$(BUILD_DIR)/%.js: %.js 
	@ mkdir -p `dirname $@`
ifneq ($(USE_LINTER),)
	@ $(call info_msg,eslint - lint,$<,$(GREEN))
	@ $(LINTER) $<
endif
ifneq ($(USE_BABEL),)
	@ $(call info_msg,babel - transplile,$@,$(BOLD)$(GREEN))
	@ $(BABEL) $< --out-file $@ 
else
	@ cp $< $@
endif

######################################
# Others
.PHONY: list-deps list-cdn phobia-deps phobia-cdn

#TODO where is mfs_excluded_libs?
#list-cdn:
#	@ $(mfs_excluded_libs)

#phobia-cdn: list-cdn
#	@ $(mfs_excluded_libs) | xargs -L1 $(BUNDLE-PHOBIA)
 
list-deps:
	@cat $(DEP_FILE)

phobia-deps: $(DEP_FILE) list-deps
	@cat $(DEP_FILE) | xargs -L1 $(BUNDLE-PHOBIA)



