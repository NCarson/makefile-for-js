#TODO find a good way to see if commands are present

#XXX dont set bool type variables to zero. 
#    DONT DO: USE_THINGY=0
#	 DO: USE_THINGY=
#	 this is because make usually checks for existance of variable being set

######################################
# Common Vars
######################################

# wipe out built in C stuff
MAKEFLAGS += --no-builtin-rules
SUFFIXES :=

# BASE_DIR defines the root of the of the project.
# It is always required to be defined in the parent.
ifeq ($(BASE_DIR),)
	$(error BASE_DIR is undefined)
endif

# directory finished files should go to
ifeq ($(TARGET_DIR),)
	$(error TARGET_DIR is undefined)
endif

# names of the finished files
ifeq ($(TARGETS),)
	$(error TARGETS is undefined)
endif

# for find command; set if you have direcs to skip
ifeq (strip($(EXCL_SRC_DIRS)),)
	_MFS_EXCLUDE = 
else
	_MFS_EXCLUDE =  -not \( $(patsubst %,-path % -prune -o,$(EXCL_SRC_DIRS)) -path $(BUILD_DIR) -prune \)
endif

######################################
# Shell Commands / Macros
######################################

NORMAL=$(shell tput sgr0)
BLACK=$(shell tput setaf 0)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
BLUE=$(shell tput setaf 4)
MAGENTA=$(shell tput setaf 5)
CYAN=$(shell tput setaf 6)
WHITE=$(shell tput setaf 7)
GRAY=$(shell tput setaf 8)

BOLD=$(shell tput bold)
BLINK=$(shell tput blink)
REVERSE=$(shell tput smso)
UNDERLINE=$(shell tput smul)

_info_msg = $(shell printf "%-25s $(3)$(2)$(NORMAL)\n" "$(1)")
define info_msg 
@printf "%-25s $(3)$(2)$(NORMAL)\n" "$(1)"
endef

######################################
# Common Rules
######################################

#XXX this should not contain any non-pattern rules as it
#	 is read first and will will wipe out the
#	 first default 'all' rule.
#

#debug variable: `make print-MYVAR`
#https://blog.melski.net/2010/11/30/makefile-hacks-print-the-value-of-any-variable/
print-%:
	@ echo '$*=$($*)'

# gzip is probably installed, sudo apt-get install gzip
GZIP ?= gzip $(GZIP_OPTIONS)
.PRECIOUS: %.gz
	#gzipped
	%.gz: %
	@ $(call info_msg,gizp - compress,$@,$(BLUE))
	@ $(GZIP) $< --stdout > $@


# everything is built in the BUILD_DIR and then moved to TARGET_DIR
$(TARGET_DIR)%: $(BUILD_DIR)%
	@ $(call info_msg,target - cp,$@,$(WHITE))
	@ mkdir -p $(shell dirname $@)
	@ cp $(patsubst $(TARGET_DIR)%,$(BUILD_DIR)%,$@) $@


