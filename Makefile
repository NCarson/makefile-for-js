MAKE_DIR := makefiles
CONFIG_DIR := configs
SRC_DIR := $(ROOT_DIR)/src

COPY := cp --no-clobber --preserve=all


ROOT_FILES = makefiles/root.makefile makefiles/npm.makefile

.PHONY: all
all: src npm

.PHONY: src
src: $(MAKE_DIR)/src.makefile
	cd $(MAKE_DIR) && mkdir -p $(SRC_DIR) && install -m644 -p -t $(SRC_DIR) src.makefile

NPM_SFX :=.mjs
.PHONY: root
root: $(NPM_FILES)
	$(COPY) $(ROOT_FILES)
