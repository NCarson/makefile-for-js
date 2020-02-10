HELP_FILE += \n\n`test.makefile`\
\n\n\#\#\# makefile library for testing diffs of test scripts\

# internal for doc builds 
ifdef _USE_COMMON
include $(DIR_MAKEJS)/lib/common.makefile
endif

######################################
#  KNOBS
######################################

######################################
#  COMMANDS
######################################

#######################################
# RULES
#######################################

#HELP +=\n\n`skeleton.makefile`

#######################################
# %.diff
# test old output against new
%.diff: %.out
	node $*.js | diff - $< > $@
	rm $@ # command succeeded; zero length file

#######################################
# %.out
# save node output of js script
.PRECIOUS: %.out
%.out: %.js
	node $< > $@

