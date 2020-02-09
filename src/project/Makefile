DIR_TARGET := ../../makefiles
TARGETS := $(DIR_TARGET)/project.makefile
FILES_SOURCES := header.makefile footer.makefile

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
# project.makefile
$(TARGETS): $(FILES_SOURCES)
	cat $(FILES_SOURCES) > $@


