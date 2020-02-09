HELP_FILE += \n\n`doc.makefile`\
\n\#\#\# Create Documenation for makefiles

# internal for doc builds 
ifdef _USE_COMMON
include $(DIR_MAKEJS)/lib/common.makefile
endif

######################################
#  KNOBS
######################################

#HELP_USE += \n\#\#\#skeleton.makefile

#HELP_USE += \n\n**USE_THINGY**: What a thingy does
#USE_THINGY := 1

#######################################
# FILES and DIRECS
#######################################

FILE_RELEASE := $(DIR_DOC_TARGET)/RELEASE
FILE_INDEX := $(DIR_DOC_TARGET)/index.md

######################################
#  COMMANDS
######################################

# npm -g install markdown-to-html
# https://github.com/cwjohan/markdown-to-html
# CMD_MARKDOWN := markdown

#######################################
# RULES
#######################################
HELP +=\n\n`doc.makefile`

#######################################
# _check_vars
# if var is not defined then error
_check_vars:
	@ $(call check_defined, TARGETS_DOC)
	@ $(call check_defined, DIR_DOC_TARGET)

#######################################
# docs/index.html
$(FILE_INDEX):
	echo '# Makefile Help\n' > $(FILE_INDEX)

#######################################
# %.makefile.md
_make_help = make --no-print-directory -f $< DIR_MAKEJS=. USE_MDLESS= _USE_COMMON=1
$(DIR_DOC_TARGET)/%.makefile.md: %.makefile
	@ echo making markdown doc for for $<  $(notdir $@)
	@ mkdir -p $(dir $@)
	@ echo '[$(notdir $@)]($*.makefile.md)\n' >> $(FILE_INDEX)
	@ echo -e '\n# $(notdir $@)' > $@
	@ $(_make_help) help-file >> $@
	@ echo -e '\n# TARGETS_DOC' >> $@
	@ $(_make_help) help >> $@
	@ echo -e '\n# USE VARIABLES' >> $@
	@ $(_make_help) help-use >> $@
	@ echo -e '\n# EXTRA HELP' >> $@
	@ $(_make_help) help-extra >> $@

#$(DIR_DOC_TARGET)/%.makefile.html : $(DIR_DOC_TARGET)/%.makefile.md
#	@ echo making html doc for for $<  $(notdir $@)
#	@ echo 'HTML <a href="$*.makefile.html"> $(notdir $@)</a><br/>' >> $(FILE_INDEX)
#	@ $(CMD_MARKDOWN) $< > $@

$(FILE_RELEASE):
	echo 'makefile-for-js\nversion ?.?.?\n\nFIXME:' > $(FILE_RELEASE)
	grep -R FIXME makefiles lib scripts >> $(FILE_RELEASE)
	echo 'TODO:' >> $(FILE_RELEASE)
	grep -R TODO makefiles lib scripts >> $(FILE_RELEASE)

######################################
# YOUR RULES and OVERIDES
######################################

