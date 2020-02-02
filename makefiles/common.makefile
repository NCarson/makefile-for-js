HELP_FILE +=\n\n**common.makefile**\
\nCommon makefile library

######################################
# Knobs
######################################

HELP_USE += \n\n**USE_MDLESS**: use mdless command to form command line markdown output \
    https://brettterpstra.com/2015/08/21/mdless-better-markdown-in-terminal
USE_MDLESS :=1

# wipe out built in C stuff
MAKEFLAGS += --no-builtin-rules
SUFFIXES :=

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

######################################
# help:
#XXX default target
HELP +=\n\n**help**: print this message
	ifneq ($(USE_MDLESS),)
	_MDLESS := $(shell echo '|' `which mdless || echo cat`)
else
	_MDLESS := | echo cat
endif
export HELP
.PHONY: help
help:
	@ echo "$$HELP" $(_MDLESS)

######################################
# printall:
HELP +=\n\n**printall**: print all variables and values known to make
	_VARS_OLD := $(.VARIABLES)
	_CUR-DIR := $(shell pwd)
printall:
	$(foreach v,                                        \
		$(filter-out $(_VARS_OLD) _VARS_OLD,$(.VARIABLES)), \
		$(info $(v) = $($(v))))

######################################
# print-%:
HELP +=\n\n**print-%**: print-varname - prints the value of varname
#https://blog.melski.net/2010/11/30/makefile-hacks-print-the-value-of-any-variable/
print-%:
	@ echo '$*=$($*)'

######################################
# help-use:
HELP +=\n\n**help-use**: print USE_VARNAME type help
export HELP_USE
.PHONY: help-use
help-use:
	@ echo "$$HELP_USE" $(_MDLESS)

######################################
# help-file:
HELP +=\n\n**help-file**: print help for makefile
export HELP_FILE
.PHONY: help-file
help-file:
	@ echo "$$HELP_FILE" $(_MDLESS)
