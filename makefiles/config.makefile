DIR_MAKE:=./makefile-for-js/makefiles
DIR_CONFIG := ./makefile-for-js/configs
DIR_BKUP := .backups
include $(DIR_MAKE)/common.makefile

_git_merge = git merge-file --stdout $< $(DIR_BKUP)/$< $(DIR_CONFIG)/$<

.DEFAULT_GOAL := diffs
diffs: test.cfg.diff

%.diff:  test.cfg $(DIR_BKUP)/test.cfg $(DIR_CONFIG)/test.cfg
	$(_git_merge) > /dev/null \
		|| $(_git_merge) > $@ # if there are diffs then write it

test.cfg: $(DIR_CONFIG)/test.cfg
	cp --no-clobber $< $@ #copy if not exists
	mkdir -p $(DIR_BKUP)
	cp --no-clobber $< $(DIR_BKUP)/$<  # copy from repo to backup dir if not exists for diffing

$(DIR_BKUP)/test.cfg: test.cfg
	mkdir -p $(DIR_BKUP)
	cp $< $(DIR_BKUP)/$< # copy from local




