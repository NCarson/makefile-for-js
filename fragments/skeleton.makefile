HELP_FILE += \n\n`skeleton.makefile`\
\n\n\#\#\# Skeleton makefile template\
\n Base file stub for style and structure.\
\n\
\n**General Style**\
\n- Format help vars in markdown. See this file for style.\
\n- 39 \# for comment headers.\
\n- 1 space between headers.\
\n- Hungarian variable notation: DIR, FILE, FILES, CMD, USE, TARGET\
\n- All files should have knobs, files, commands, rules headers in the correct order (see this file.)\
\n- All no pattern rules should have a sub header\
\n- *todo* and *fixme* should be give context without other lines being included\
\
\n**Variable style**\
\n- non undscore prepended vars are *public* cmd line changeable\
\n- undscore prepended vars are *private*; code should be examined before changing.\
\n- recrusive `=` (computed each time like a function) variables are lower case\
\n- simple `:= +=` (computed once) variables are upper case\
\
\n**Help Style Guide**\
\n- non pattern rules should have a `HELP` comment set. See this file for style.\
\n- knob variables (USE THINGY) should have a `HELP_USE` comment set. See this file for style.\
\n- files should have a `HELP_FILE` comment set. See this file for style.\

# internal for doc builds 
ifdef _USE_COMMON
include $(DIR_MAKEJS)/lib/common.makefile
endif

######################################
#  KNOBS
######################################

#HELP_USE += \n\n`skeleton.makefile`

#HELP_USE += \n\n**USE_THINGY**: What a thingy does
#USE_THINGY := 1

#######################################
# FILES and DIRECS
#######################################

######################################
#  COMMANDS
######################################

#CMD_GIT := git

#######################################
# RULES
#######################################
HELP +=\n\n`skeleton.makefile`

.DEFAULT_GOAL := help-file # this will reset default from common.makefile (default is help).

#######################################
# all
#HELP +=\n\n**all**: help for all
#.PHONY: all
#all: $(FILE_COMMIT)

#######################################
# %.diff
# pattern rules dont need help var but should have comment description
#_FILE_REPO := $(DIR_CACHE)/old_repo # vars that are used in just one rule should be with rule
#%.diff:
#	cd $(DIR_MAKEJS) && $(CMD_GIT) checkout $(_commit) $(GIT_PRJ_ROOT)/$* #get version when we installed


