#######################################
#  UMD LIBRARY BUILD
 
DIR_TARGET := $(DIR_PRJ_ROOT)/lib# library type
UMD_BASENAME :=umd# XXX this needs to be different from the source file names #FIXME does it??
TARGETS := $(DIR_TARGET)/$(UMD_BASENAME).js

#TARGETS := \
#    $(DIR_TARGET)/$(UMD_BASENAME).js \
#    $(DIR_TARGET)/$(UMD_BASENAME).min.js \
#    $(DIR_TARGET)/$(UMD_BASENAME).min.js.gz \ # all components bundled
#    $(DIR_TARGET)/PostgrestFetcher.js \ # for individual imports
#	 $(DIR_TARGET)/PostgrestQuery.js # etc ...
#
#    find all source files (on default export per file) and append ../lib direc to them
#    leave out index as that probably goes in PROJECT_ROOT
#TARGETS := $(shell find . -path $(DIR_BUILD) -prune -o -name '*.js' -print \
#	| grep -v ^./index.js$ \
#	| cut -b1-2 --complement \
#	| awk '{print "$(DIR_TARGET)/"$$0}'  \
#	)
#	 TARGETS += $(patsubst %.js,%.min.js,$(TARGETS))# minified
#    TARGETS += $(patsubst %.js,%.min.js.gz,$(TARGETS))# gzipped
#    TARGETS += ../index.js# an index that imports all targets

