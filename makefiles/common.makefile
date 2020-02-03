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

_NORMAL=$(shell tput sgr0)
_BLACK=$(shell tput setaf 0)
_RED=$(shell tput setaf 1)
_GREEN=$(shell tput setaf 2)
_YELLOW=$(shell tput setaf 3)
_BLUE=$(shell tput setaf 4)
_MAGENTA=$(shell tput setaf 5)
_CYAN=$(shell tput setaf 6)
_WHITE=$(shell tput setaf 7)
_GRAY=$(shell tput setaf 8)

_BOLD=$(shell tput bold)
_BLINK=$(shell tput blink)
_REVERSE=$(shell tput smso)
_UNDERLINE=$(shell tput smul)

_info_msg = $(shell printf "%-25s $(3)$(2)$(NORMAL)\n" "$(1)")
define info_msg 
@printf "%-25s $(3)$(2)$(_NORMAL)\n" "$(1)"
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
printall:
	$(foreach v,\
		$(sort $(filter-out $(_VARS_OLD) _VARS_OLD, $(.VARIABLES))), \
		$(info $(v);$(origin $(v)) = $($(v))  ))

# filter out env, default and auto vars
_FILTERED_VARS := $(foreach V,\
	$(.VARIABLES),\
	$(if $(filter-out environment default automatic,$(origin $V)), $V))

# filter out leader underscore vars
_FILTERED_VARS2 := $(foreach V,\
	$(_FILTERED_VARS),\
	$(if $(filter-out _% HELP HELP_FILE HELP_USE,$V), $V))

.PHONY: printvars
printvars:
	$(foreach v,\
		$(sort $(_FILTERED_VARS2)),\
		$(info $(origin $(v));$(v) = $($(v)) ))

#this is good for starter
#https://medium.com/stack-me-up/using-makefiles-the-right-way-a82091286950

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
