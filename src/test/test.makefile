
######################################
#  FILES and DIRECS
######################################

#XXX dont add trailing '/' to paths
FILES_SRC := $(shell find . -name '*.js')
TARGETS := $(FILES_SRC:%.js=%.out)
DIFFS := $(FILES_SRC:%.js=%.diff)

####################################
# RULES
####################################

####################################
# all
HELP +=\n\n**all**: write diff files (hopefully zero length) comparing old node output to new
.PHONY: all force
all: $(DIFFS)

.PHONY: force
force: ;

####################################
# clean
HELP +=\n\n**clean**: Remove `TARGETS` and diffs.
.PHONY: clean
clean:
	rm -f $(TARGETS) $(DIFFS)
