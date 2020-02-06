HELP_FILE += \n\# Makefile\
\n\#\#\# Internal makefile for makefile-for-js

######################################
#  KNOBS
######################################

#HELP_USE += \n\#\#\#skeleton.makefile
#USE_THINGY := 1
#HELP_USE += \n\n**USE_THINGY**: What a thingy does

#######################################
# FILES and DIRECS
#######################################

DIR_MAKEJS := .
DIR_DOCS := ./docs
DIR_INSTALL := ..

FILE_HEADER := .html/.header.html
FILE_FOOTER := .html/.footer.html
FILE_BODY := $(DIR_DOCS)/body.html
FILE_INDEX := $(DIR_DOCS)/index.html

FILES_MAKE := $(shell find ./makefiles -name '*.makefile')
FILES_MD_MAKE := $(FILES_MAKE:%=$(DIR_DOCS)/%.md)
FILES_HTML_MAKE := $(FILES_MAKE:%=$(DIR_DOCS)/%.html)

######################################
#  COMMANDS
######################################

#npm -g install markdown-to-html
CMD_MARKDOWN := markdown

#XXX watch were we put this. as it will have diffent results in different locations
include $(DIR_MAKEJS)/lib/common.makefile

#######################################
# RULES
#######################################
HELP +=\n\#\#\#Makefile

#.DEFAULT_GOAL := help-file # this will reset default from common.makefile (default is help).

#######################################
# all
HELP +=\n\n**all**: make install
.PHONY: all
all: install

#######################################
# git-doc-commit
HELP +=\n\n**git-doc-commit**: boilerplate add commmit with message
.PHONY: git-doc-commit
git-doc-commit:
	git add .
	git commit -m 'updated doc'

#######################################
# install
HELP +=\n\n**install**: copy project to `DIR_INSTALL`
.PHONY: install
install:
	cp --no-clobber makefiles/project.makefile $(DIR_INSTALL)
	echo DIR_MAKEJS := $(CURDIR) >> $(DIR_INSTALL)/project.makefile

#######################################
# doc-clean
.PHONY: doc-clean
HELP +=\n\n**doc-clean**: remove files in doc directory
doc-clean:
	rm -fr $(DIR_DOCS)/*

#######################################
# docs
.PHONY: doc
HELP +=\n\n**docs**: write out help file for makefiles to doc directory
doc: $(FILE_BODY) $(FILES_MD_MAKE) $(FILES_HTML_MAKE) $(FILE_INDEX)

#######################################
# docs/index.html
$(FILE_INDEX):
	cat $(FILE_HEADER) $(FILE_BODY) $(FILE_FOOTER)  > $(FILE_INDEX)

#######################################
# docs/.body.html
$(FILE_BODY):
	echo '<h2>Makefile Help</h2>' > $(FILE_BODY)

#######################################
# %.makefile.md
_make_help = make --no-print-directory -f $< DIR_MAKEJS=. USE_MDLESS= 
$(DIR_DOCS)/%.makefile.md: %.makefile
	@ echo making markdown doc for for $<  $(notdir $@)
	@ echo 'MD <a href="$*.makefile.md"> $(notdir $@)</a><br/>' >> $(FILE_BODY)
	@ mkdir -p $(dir $@)
	@ echo -e '\n# $(notdir $@)' > $@
	@ $(_make_help) help-file >> $@
	@ echo -e '\n# TARGETS' >> $@
	@ $(_make_help) help >> $@
	@ echo -e '\n# USE VARIABLES' >> $@
	@ $(_make_help) help-use >> $@
	@ echo -e '\n# EXTRA HELP' >> $@
	@ $(_make_help) help-extra >> $@

$(DIR_DOCS)/%.makefile.html : $(DIR_DOCS)/%.makefile.md
	@ echo making html doc for for $<  $(notdir $@)
	@ echo 'HTML <a href="$*.makefile.html"> $(notdir $@)</a><br/>' >> $(FILE_BODY)
	@ $(CMD_MARKDOWN) $< > $@


######################################
# YOUR RULES and OVERIDES
######################################

