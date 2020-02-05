HELP_FILE += \n\#common.makefile\
\n\#\#\#Common makefile library\
\nrun `make help` see top level non-pattern rules\
\nrun `make help-file` help for each included file\
\nrun `make help-use` help for USE_\% type variables\
\nrun `make -j 8` to run with 8 threads in paralell (set the number to number of cores)! \
\nrun `make -n` for a dry run that will print out the actually commands it would have used \
\nrun `make --trace` to see all recipe shell commands\
\nrun `make --debug=b` basic debug dependency chain \
\n\#\#\#\# Dont set bool type variables to zero.\
\nBAD: `USE_THINGY :=0`\
\nGOOD: `USE_THINGY :=`\
\nThis is because make usually checks for existance of variable being set.\
\n\#\#\#\#Watch out with spaces when setting variables.\
\nMake is very literal in setting things.\
\nBAD: `DIR_BASE := .. \\\\n`\# will evaluate to '.. '\
\nGOOD: `DIR_BASE := ..\\\\n`\# will evaluate to '..'\
\nSo the value starts right after assingment symbol and ends at newline or comment hash.\
\n\#\#\#\#Dont set variables with the environment\
\nThe -e switch will push the whole environment in and who knows whats in there.\
\nSetting variables after the the make command will isolate and document what you are trying to do.\
\nBAD: `USE_THINGY=1 make -e`\# set through environment\
\nGOOD: `make USE_THINGY=1`\# set by make

# wipe out built in C stuff
MAKEFLAGS += --no-builtin-rules --no-builtin-variables
SUFFIXES :=

######################################
# Knobs
######################################

HELP_USE += **USE_MDLESS**: use mdless command to form command line markdown output \
    https://brettterpstra.com/2015/08/21/mdless-better-markdown-in-terminal
USE_MDLESS :=1

HELP_USE += \n\n**USE_COLOR**: colorize output
USE_COLOR :=1

#######################################
# FILES and DIRECS
#######################################

######################################
#  COMMANDS
######################################

CMD_MDLESS := mdless

ifdef USE_MDLESS
_MDLESS := $(shell echo '|' `which $(CMD_MDLESS) || echo cat`)
else
_MDLESS := echo '| echo cat'
endif

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

ifdef USE_COLOR
define _info_msg 
	@ printf "%-25s $(3)$(2)$(_NORMAL)\n" "$(1)"
endef
else
define _info_msg 
	@printf "%-25s $(2)\n" "$(1)"
endef
endif

#######################################
# RULES
#######################################

#######################################
# help:
HELP +=\n\n**help**: print this message
export HELP
.PHONY: help
#XXX will be default target unless .DEFAULT_GOAL is set
help:
	@ echo "$$HELP" $(_MDLESS)

#######################################
# printall:
HELP +=\n\n**printall**: print all public type variables\
	(no underscore; defined in file or command line or environment override)

# filter out env, default and auto vars
_FILTERED_VARS := $(foreach V,\
	$(.VARIABLES),\
	$(if $(filter-out environment default automatic,$(origin $V)), $V))

# filter out leader underscore vars
_FILTERED_VARS2 := $(foreach V,\
	$(_FILTERED_VARS),\
	$(if $(filter-out _% HELP HELP_FILE HELP_USE,$V), $V))

.PHONY: printvars
printall:
	$(foreach v,\
		$(sort $(_FILTERED_VARS2)),\
		$(info $(origin $(v));$(v) = $($(v)) ))


#######################################
# printall-raw:
HELP +=\n\n**printall-raw**: print all variables and values known to make
printall-raw:
	$(foreach v,\
		$(sort $(.VARIABLES)),\
		$(info $(origin $(v));$(v) = $($(v)) ))

#######################################
# print-%:
HELP +=\n\n**print-%**: print-varname - prints the value of varname
#https://blog.melski.net/2010/11/30/makefile-hacks-print-the-value-of-any-variable/
print-%:
	@ echo '$*=$($*)'

#######################################
# help-use:
HELP +=\n\n**help-use**: print USE_VARNAME type help
export HELP_USE
.PHONY: help-use
help-use:
	@ echo "$$HELP_USE" $(_MDLESS)

#######################################
# help-file:
HELP +=\n\n**help-file**: print help for makefile
export HELP_FILE
.PHONY: help-file
help-file:
	@ echo "$$HELP_FILE" $(_MDLESS)
