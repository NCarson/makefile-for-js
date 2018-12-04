# XXX leading direcs with '../' or './' ARE IMPORTANT
BASE_DIR = ..
TARGET_DIR = $(BASE_DIR)/public/
# XXX these are main targets to build
# remove them if you dont want to build them
TARGETS = $(TARGET_DIR)/index.html \
		$(TARGET_DIR)/index.html.gz

include $(BASE_DIR)/js.makefile

.PHONY: clean

clean:
	rm -f $(TARGETS)
	rm -fr $(BUILD_DIR)

