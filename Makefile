MAKE_DIR := makefiles
CONFIG_DIR := configs
ROOT_DIR := $(shell cd ..; echo `pwd`)
SRC_DIR := $(ROOT_DIR)/src

NPM_FILES := \
	$(CONFIG_DIR)/eslintrc.js.mjs  \
	$(CONFIG_DIR)/exclude.cdn.json.mjs \
	$(CONFIG_DIR)/npmignore.mjs \
	$(CONFIG_DIR)/gitignore.mjs \
	$(CONFIG_DIR)/package.json.mjs

all: src npm

.PHONY: src
src: $(MAKE_DIR)/src.makefile
	cd $(MAKE_DIR) && mkdir -p $(SRC_DIR) && install -m644 -p -t $(SRC_DIR) src.makefile

.PHONY: npm
npm: $(NPM_FILES)
	install -m644 -p -t $(ROOT_DIR) $(NPM_FILES) $(MAKE_DIR)/root.makefile
