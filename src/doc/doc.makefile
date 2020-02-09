HELP_FILE += \
\n\n\#\#\# @makefile-for-js/lib

######################################
#  KNOBS
######################################

#HELP_USE += \n\n`skeleton.makefile`
#USE_THINGY := 1
#HELP_USE += \n\n**USE_THINGY**: What a thingy does

#######################################
# FILES and DIRECS
#######################################

FILES_DOC_SRC := $(shell find . -name '*.makefile' -type f | sed 's|^./||') #FIXME figure out who were serving this to
DIR_DOC_TARGET := ./docs
TARGETS_DOC := $(FILES_DOC_SRC:%=$(DIR_DOC_TARGET)/%.md)

DIR_PRJ_ROOT := ..
DIR_MAKEJS_LIB := $(DIR_PRJ_ROOT)/node_modules/makefile-for-js/lib

######################################
#  COMMANDS
######################################

#######################################
# RULES
#######################################

.DEFAULT_GOAL := all # this will reset default from common.makefile (default is help).

#######################################
# all
.DEFAULT_TARGET := all
HELP +=\n\n**all**: make docs
.PHONY: all
all: $(TARGETS_DOC)

#######################################
# clean
HELP +=\n\n**clean**: remove docs
.PHONY: clean
clean: 
	rm -fr $(DIR_DOC_TARGET)

DIR_MAKEJS := ../../makefiles
include $(DIR_MAKEJS)/lib/doc.makefile
include $(DIR_MAKEJS)/lib/common.makefile
