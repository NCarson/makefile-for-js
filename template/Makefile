# XXX leading direcs with '..' or './' ARE IMPORTANT
BASE_DIR = ..
BUILD_DIR = ./
TARGET_DIR = $(BASE_DIR)/public
# XXX these are main targets to build
# remove them if you dont want to build them
TARGETS = $(TARGET_DIR)/index.html

include $(BASE_DIR)/js.makefile

.PHONY: clean

clean:
	rm -f $(TARGETS) index.html

