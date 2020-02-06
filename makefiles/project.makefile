HELP_FILE += \n\#project.makefile\
\n\#\#\#Project Management makefile\
\n- Installs package directory configs and directory skeleton.\
\n- Installs npm compile tools.\
\n- handles version control of local makefiles.

######################################
#  KNOBS
######################################

#HELP_USE += \n\n**PRODUCTION**: If set then use production options instead of development\

#######################################
# FILES and DIRECS
#######################################

DIR_MAKEJS := ./makefile-for-js
GIT_PRJ_ROOT := project-skel/vanilla
DIR_PRJ_ROOT := $(DIR_MAKEJS)/$(GIT_PRJ_ROOT)
DIR_CACHE := .makefilejs

FILE_MANIFEST := $(DIR_CACHE)/MANIFEST
FILE_COMMIT := $(DIR_CACHE)/COMMIT
FILES_PRJ_ROOT := $(shell find $(DIR_PRJ_ROOT) -type f)

######################################
#  COMMANDS
######################################

CMD_GIT := git
CMD_NPM := npm

_global_packages = $(shell cat $(DIR_CACHE)/GLOBAL_PACKAGES)
_packages = $(shell cat $(DIR_CACHE)/PACKAGES)
_commit = $(shell cat $(FILE_COMMIT))
_mnf_files = $(shell cat $(FILE_MANIFEST))
_git_status = $(shell cd $(DIR_MAKEJS) && git status --porcelain)
_git_current_commit = $(shell cd $(DIR_MAKEJS) && $(CMD_GIT) rev-list --max-count=1 HEAD)

include $(DIR_MAKEJS)/lib/common.makefile

#######################################
# RULES
#######################################

HELP +=\n\#\#\#project.makefile

#######################################
# all
HELP +=\n\n**all**: runs files and npm-install rules
.DEFAULT_GOAL := all
.PHONY: all
all: files npm-install

#######################################
# files
HELP +=\n\n**files**: install new files from `DIR_PRJ_ROOT`
.PHONY: files
files: $(FILE_COMMIT) 

#######################################
# clean
HELP +=\n\n**clean**: removes files that were added by 'all' rule using the manifset file in `DIR_CACHE`
.PHONY: clean
clean:
	rm --interactive=once $(_mnf_files) $(FILE_COMMIT) $(FILE_MANIFEST)

#######################################
# npm-install
HELP +=\n\n**npm-install**: install compile plugins locally
.PHONY: npm-install
npm-install:
	$(CMD_NPM) i $(_packages)

#######################################
# npm-install-global
HELP +=\n\n**npm-install-global**: installs compile tools globaly for command line usage
.PHONY: npm-install-global
npm-install-global:
	sudo $(CMD_NPM) i -g $(_global_packages)

#######################################
# diffs
HELP +=\n\n**diffs**: make diff files if needed from MANIFEST files\
\n    Uses `git merge-file <current-file> <base-file> <other-file>` where\
\n    where current is your local file; base-file is the original repo file from `make install`;\
\n    and other-file is the new repo file. If there is difference will create a file named\
\n    'your-file.diff'. It is up to the caller to merge the difference by hand. After\
\n    edits are finished and integerated into your source (FIXME see FILE_COMMIT)\ reinstall files to get a new commit hash.
.PHONY: diffs
ifneq ($(_git_current_commit),$(shell cat $(FILE_COMMIT))) #1
ifeq ($(_git_status),) #2
diffs: $(_mnf_files:%=%.diff)
else #2
diffs:
	@ echo $(DIR_MAKEJS) not clean. please commit before running diffs
endif #2
else #1
diffs:
	@ echo $(DIR_MAKEJS) on same commit as $(FILE_COMMIT)
endif #1

#######################################
# .makefilejs/COMMIT
HELP +=\n\n**.makefilejs/COMMIT**: copys skeleton directory and git commit hash from `DIR_PRJ_ROOT`
# FIXME: check that COMMIT depends on makefilejs direc
$(FILE_COMMIT): $(FILE_MANIFEST)
	cp --no-clobber -RL $(DIR_PRJ_ROOT)/. ./ #dots and dashes count
	touch $(CURDIR)/$(FILE_COMMIT)
	cp $(CURDIR)/$(FILE_COMMIT) $(CURDIR)/$(FILE_COMMIT).old
	echo $(_git_current_commit) > $(CURDIR)/$(FILE_COMMIT)

#######################################
# .makefilejs/MANIFEST 
HELP +=\n\n**.makefilejs/MANIFEST**: record of files from skeleton directory in `DIR_PRJ_ROOT`
$(FILE_MANIFEST): $(FILES_PRJ_ROOT)
	mkdir -p `cd $(DIR_PRJ_ROOT) && find . -type d | tr "\n" " "`
	cd $(DIR_PRJ_ROOT) && find -L . -type f > $(CURDIR)/$(FILE_MANIFEST)

#######################################
# %.diff
# make diffs against original commit of file
# XXX lame ass git gives positive exit codes as the number of conflicts.
#     Sooo, we eat the exit code and dont know if it 'realy' failed with a negative code.
_FILE_REPO := $(DIR_CACHE)/old_repo
_git_merge = $(CMD_GIT) merge-file --stdout $* $(_FILE_REPO) $(DIR_PRJ_ROOT)/$*
_DEV_NULL := >/dev/null 2>&1
%.diff:
	 @ echo checking diffs for $*
	 @ cd $(DIR_MAKEJS) && $(CMD_GIT) checkout $(_commit) $(GIT_PRJ_ROOT)/$* #get version when we installed
	 @ cp $(DIR_PRJ_ROOT)/$* $(_FILE_REPO) #make cpy of old repo file
	 @ cd $(DIR_MAKEJS) && $(CMD_GIT) checkout master $(_DEV_NULL)
	 @ cd $(DIR_MAKEJS) && $(CMD_GIT) reset --hard $(_DEV_NULL)
	 @ $(_git_merge) > /dev/null \
	 	|| (echo '$(_YELLOW)> $@ $(_NORMAL)' && $(_git_merge) > $@ || true) # if there are diffs then write it 

######################################
# YOUR RULES and OVERIDES
######################################

