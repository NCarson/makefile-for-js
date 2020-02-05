HELP_FILE += \n\#root.makefile\
\n\#\#\#Top Level Project Makefile\
\n- Makes source sub dirs\
\n- publishes npm package\


######################################
#  KNOBS
######################################

#USE_THINGY := 1
#HELP_USE += \n\n**USE_THINGY**: What a thingy does

#######################################
# FILES and DIRECS
#######################################

DIR_MAKEJS := ./makefile-for-js

######################################
#  COMMANDS
######################################

CMD_GIT := npm
CMD_NPM_VERSION := npm version
CMD_NPM_VERSION_OPTIONS := patch
CMD_NPM_PUBLISH := npm publish
CMD_NPM_PUBLISH_OPTIONS :=

#XXX watch were we put this. as it will have diffent results in different locations
include $(DIR_MAKEJS)/lib/common.makefile

#######################################
# RULES
#######################################
HELP +=\n\#\#\#root.makefile

.DEFAULT_GOAL := all
HELP +=\n\n**all**: make all sub makes
export HELP
.PHONY: help
all:
	$(MAKE) -C src

HELP +=\n\n**clean**: clean all sub makes
clean:
	$(MAKE) -C src clean

HELP +=\n\n**publish**: publish package to npm registery

publish: clean
	$(MAKE) -C src USE_PRODUCTION=1
	echo `pwd`
	$(CMD_NPM_VERSION) $(CMD_NPM_VERSION_OPTIONS)
	$(CMD_NPM_PUBLISH) $(CMD_NPM_VERSION_PUBLISH)
	$(CMD_GIT) push --tags

#TODO add separate makefile for documentation
#docs:
#	cd src && make docs
#
#commit-doc:
#	git add docs README.md
#	git commit -m "updated doc"
#	git push

######################################
# YOUR RULES and OVERIDES
######################################

