# this has to set before the include
BASE_DIR := ./
# XXX We use conf.Makefile instead of js.Makefile since 
# we are going to define are own targets.
include .conf.makefile

# in case these actually exist as files `make` would be confused without .PHONY
.PHONY: all clean template code cdn

# The first rule in a makefile is the default if you just type `make`.
# Traditionally is called all
all: template static

# rm all build files and start fresh
clean: clean-gz
	cd src && $(MAKE) clean
	cd src/codesplit && $(MAKE) clean
	cd src/umd && $(MAKE) clean
	cd template && $(MAKE) clean

# If a dependency chain breaks and the gz file
# is not being updated, you can scratch your head
# for hours on why your changes are not working.
clean-gz:
	rm -f $(COMPRESS_FILES_GZ) 

# This makes sure all the code is already built before it makes the templates.
template: code $(IDX_JSON)
	cd template && $(MAKE)

# js code
code:
	cd src/umd && $(MAKE)
	cd src/codesplit && $(MAKE)
	cd src && $(MAKE)

# copy files to start new project
repo:
	mkdir -p repo/public/dist
	mkdir -p repo/src
	cp src/Makefile repo/src.Makefile
	cp src/codesplit/Makefile repo/codesplit.Makefile
	cp src/umd/Makefile repo/umd.Makefile
	cp Makefile .conf.makefile .js.makefile config.dev.js config.prod.js repo/
	mkdir -p repo/template
	cp template/index.mustache repo/template
	
# gzip static stuff
# this  does not have to do anything
# since .gz files have a rule in .conf.makefile
# gzip static assets
COMPRESS_FILES := $(shell find $(STATIC_DIR)/ \
	-name '*.svg' \
	-o -name '*.html' \
	-o -name '*.css')
COMPRESS_FILES_GZ := $(patsubst %,%.gz,$(COMPRESS_FILES))
static: $(COMPRESS_FILES_GZ)

