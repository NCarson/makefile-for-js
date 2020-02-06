
FILES_MAKE = $(shell find ./makefiles -name '*.makefile')

.PHONY: docs
docs: $(FILES_MAKE:%=%.md)

%.makefile.md: %.makefile
	make -f $< help-file DIR_MAKEJS=. USE_MDLESS= > $@
	make -f $< help-use DIR_MAKEJS=. USE_MDLESS= >> $@
	make -f $< help DIR_MAKEJS=. USE_MDLESS= >> $@
