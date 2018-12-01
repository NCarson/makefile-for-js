
BASE_DIR := ./

include conf.makefile

.PHONY: all clean template code cdn

all: template

clean:
	cd src/codesplit && make clean
	cd src && make clean
	cd template && make clean

template: code cdn
	cd template && make

code:
	cd src/codesplit && make
	cd src && make

cdn:
ifdef PRODUCTION
	$(shell $(call set_template_val,cdns,$(call get_prod_cdns)))
else
	$(shell $(call set_template_val,cdns,$(call get_dev_cdns)))
endif

