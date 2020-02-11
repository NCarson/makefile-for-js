HELP_FILE += \n\n`project.makefile`\
\n\n\#\#\# Project Management makefile\

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

#######################################
#  COMMANDS
#######################################

CMD_NPM := npm
CMD_GIT := git

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

#######################################
# npm-publish
HELP +=\n\n**npm-publish**: commit; publish with version patch; push with tags
.PHONY: npm-publish
npm-publish:
	#$(MAKE) -C src USE_PRODUCTION=1
	$(CMD_GIT) add .
	$(CMD_GIT) commit; 
	$(CMD_NPM) version patch
	$(CMD_NPM) publish
	$(CMD_GIT) push --tags

#######################################
# git-commit-doc
HELP +=\n\n**git-commit-doc**: TODO
.PHONY: git-commit-doc
git-commit-doc: #FIXME add doc direcs
	git add README.md
	git commit -m "updated doc"
	git push
