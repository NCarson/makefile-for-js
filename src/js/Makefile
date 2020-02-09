FILES_SRC := umd.makefile bundle.makefile
DIR_TARGET := ../../makefiles
TARGETS := $(FILES_SRC:%=$(DIR_TARGET)/%)

include ../../lib/common.makefile

#######################################
# all
HELP +=\n\n**all**: make `TARGETS` and place into `DIR_TARGET`
.DEFAULT_GOAL := all
.PHONY: all
all: $(TARGETS)

#######################################
# clean
HELP +=\n\n**all**: remove `TARGETS`
.PHONY: clean
clean:
	rm $(TARGETS)

#######################################
#../lib/%.makefile
$(DIR_TARGET)/%.makefile: %.makefile
	cat header.makefile $< footer.makefile > $@


