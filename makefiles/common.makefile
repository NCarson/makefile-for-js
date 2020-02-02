######################################
# Common Vars
######################################

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

#XXX this should not contain any non-pattern rules as it
#	 is read first and will will wipe out the
#	 first default 'all' rule.
#

#debug variable: `make print-MYVAR`
#https://blog.melski.net/2010/11/30/makefile-hacks-print-the-value-of-any-variable/
print-%:
	@ echo '$*=$($*)'
MJS_HELP +=\nprint-%: print-varname - prints the value of varname

_VARS_OLD := $(.VARIABLES)
CUR-DIR := $(shell pwd)
printall:
	$(foreach v,                                        \
		  $(filter-out $(_VARS_OLD) _VARS_OLD,$(.VARIABLES)), \
		  $(info $(v) = $($(v))))
MJS_HELP +=\nprintall: print all variables and values known to make

export MJS_HELP
.PHONY: help
help:
	@ echo "$$MJS_HELP"
MJS_HELP +=\nhelp: print this message

