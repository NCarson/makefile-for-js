SRC_CONFIG ?= $(SRC_DIR)config.js
CONFIG_PROD ?= $(BASE_DIR)/config.prod.js
CONFIG_DEV ?= $(BASE_DIR)/config.dev.js
ifdef PRODUCTION
	CONFIG ?= $(CONFIG_PROD)
	export PRODUCTION
else
	CONFIG ?= $(CONFIG_DEV)
endif


ifdef USE_CONFIG #FIXME
	# switch out dev or prod config if necessary
	ifneq ($(realpath $(CONFIG)),$(shell realpath $(SRC_CONFIG)))
	$(info $(call _info_msg,config - link,$(CONFIG),$(GREEN)))
	$(shell test -f $(SRC_CONFIG) && rm -f $(SRC_CONFIG))
	$(shell rm -f $(SRC_CONFIG))
	$(shell ln -s $(CONFIG) $(SRC_CONFIG))
	$(shell touch $(SRC_CONFIG))
endif
