HELP_FILE += \n\n`project.makefile`\
\n\n\#\#\# Project Management makefile\
\nInstall directory skeleton and project configs. \
\nInstalls npm packages for compiling.\
\nHandles peer version control of local makefiles and configs.

######################################
#  KNOBS
######################################

HELP_USE += \n\n`project.makefile`

HELP_USE += \n\n**USE GLOBAL COMPILE**: Install development compile tools globally.\
\n    If not set will install to package.
USE_GLOBAL_COMPILE ?=0

HELP_USE += \n\n**USE GLOBAL PLUGIN COMPILE**: Install plugins globally and then link them in project.\
\n    If not set will install to package.
USE_GLOBAL_PLUGIN_COMPILE ?=0

# node_modules disk size with global install!!!!
#$ du -hsc node_modules/
#256K    node_modules/
#256K    total

#######################################
# FILES and DIRECS
#######################################

######################################
#  COMMANDS
######################################

CMD_NPM := npm
_GLOBAL_PACKAGES := $(shell cat $(DIR_MAKEJS)/data/GLOBAL_PACKAGES)
_PLUGIN_PACKAGES := $(shell cat $(DIR_MAKEJS)/data/PLUGIN_PACKAGES)
_NPM_ROOT := $(shell npm -g root)
# lets them be installed like links but babel and others will load them
_PLUGIN_PACKAGES_FULL = $(_PLUGIN_PACKAGES:%=$(_NPM_ROOT)/%)


#######################################
# RULES
#######################################

HELP +=\n\n`project.makefile`
#######################################
# npm-install
#
HELP +=\n\n**npm-install**: install development packages\
\n    Global installs will probably require root `sudo make npm-install`

ifdef USE_GLOBAL_COMPILE
_INSTALL_FLAG := -g
endif

.PHONY: npm-install
npm-install:
	$(CMD_NPM) -D $(_INSTALL_FLAG) install $(_GLOBAL_PACKAGES)
ifdef USE_GLOBAL_PLUGIN_COMPILE
	$(CMD_NPM) -D install $(_PLUGIN_PACKAGES_FULL) #will make a path type install in package.json to global node modules `npm -g root`
else
	$(CMD_NPM) -D install $(_PLUGIN_PACKAGES) # will install to package
endif
