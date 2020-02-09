DIR_PRJ_ROOT := ..
DIR_MAKEJS_LIB := $(DIR_PRJ_ROOT)/node_modules/makefile-for-js/lib
DIR_TARGET := ../../makefiles
TARGETS := ../../makefiles/doc.makefile

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
	cp $< $@

include $(DIR_MAKEJS_LIB)/common.makefile

