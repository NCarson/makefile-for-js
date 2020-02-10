
######################################
#  FILES and DIRECS
######################################

#XXX dont add trailing '/' to paths
#DIR_SRC := .

#######################################
#  PACKAGE BUILD

#DIR_TARGET := .
#TARGETS :=

####################################
# RULES
####################################

HELP +=\n\n**all**: Make `TARGETS`.
.PHONY: all
all: $(TARGETS)
.DEFAULT_GOAL := all

HELP +=\n\n**clean**: Remove `TARGETS`.
.PHONY: clean
clean:
	rm -f $(TARGETS)

######################################
# INCLUDES
######################################

include $(DIR_MAKEJS)/lib/common.makefile

######################################
# YOUR RULES and OVERIDES
######################################

# overide variables and rules here so you will overwrite
# the include makefiles instead of the other way around
#
