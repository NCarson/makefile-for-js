####################################
# RULES
####################################

HELP +=\n\n**all**: Make the `TARGETS`.
.PHONY: all
all: $(TARGETS)
.DEFAULT_GOAL := all

HELP +=\n\n**clean**: Remove `TARGETS` and `DIR_BUILD`.
.PHONY: clean
clean:
	rm -f $(TARGETS)
	rm -fr $(DIR_BUILD)

######################################
# INCLUDES
######################################

include $(DIR_MAKEJS)/lib/js.makefile 
include $(DIR_MAKEJS)/lib/common.makefile

######################################
# YOUR RULES and OVERIDES
######################################

# overide variables and rules here so you will overwrite
# the include makefiles instead of the other way around
#
