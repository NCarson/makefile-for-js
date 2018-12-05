
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
#  Phonies
######################################

.PHONY: all phobia

all: $(BUILD_DIR) $(IDX_JSON) $(TARGETS)

phobia:
	@cat $(DEP_FILE)
	@cat $(DEP_FILE) | xargs -L1 $(BUNDLE-PHOBIA)

######################################
#  Rules
######################################

$(IDX_JSON): 
	@echo "{}" > $(IDX_JSON)

$(BUILD_DIR):
	@mkdir -p $@

$(PACKAGE_LOCK):
	@touch $(PACKAGE_LOCK)


# check file 2 doest not exists or file 1 is newer
file_newer = $(shell if [ -f $(2) ]; then if [ $(1) -nt $(2) ]; then echo 1; else echo 0; fi; else echo 1; fi)
# We only want to run this when need to since
# it needs to depend on ES5_FILES .
# It would remake itself on every compile
# and we dont want to rebuild the vendor bundle that much
# so we only put it in when PACKAGE_LOCK is new.
ifeq ($(call file_newer,$(PACKAGE_LOCK),$(DEP_FILE)),1)
$(info package-lock newer)
#write dependencies
$(DEP_FILE): $(PACKAGE_LOCK) $(ES5_FILES)
	@$(BROWSERIFY) --list $(ES5_FILES) | $(STRIP_DEPS) > $(DEP_FILE) 
endif

