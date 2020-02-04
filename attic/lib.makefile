
include .gmsl.makefile

# only evel if its gets used
#SHALIST = $(eval SHALIST := $(shell find . -name '*.c' | xargs shasum))$(SHALIST)


### command-path - returns absoulute path of command (which)
### $(shell $2 which $1)
### $(call command-path,ls,PATH=/my/special/direc)
command-path = $(__gmsl_tr2)$(shell $2 which $1)

### command-path-or-fail - returns absolute path of command or error
### see command-path
command-path-or-fail = $(__gmsl_tr3)$(if \
	$(call command-path,$1,$2),\
	$(call command-path,$1,$2),\
	$(error $3='$1' missing and needed for this build))

### command-path-or-fail - returns absolute path of command or error or nothing if $1 is empty
### see command-path-or-fail
command-path-or-fail-empty-ok = $(__gmsl_tr3)$(if $1,$(call command-path-or-fail,$1,$2,$3))

BABEL := lsss

$(info $(call command-path-or-fail,$(BABEL),,BABEL))

.PHONY: all
all:
	echo hi

_printvars = \
	$(foreach V,$(sort $(.VARIABLES)), \
	$(if $(filter-out environ% default automatic, \
	(origin $V)),$(info $V=$($V) ($(value $V)))))

.PHONY: printvars
printvars: ; @$(info $(_printvars))

ifdef TRACE
.PHONY: _trace _value
_trace:
	@$(MAKE) --no-print-directory TRACE= \
	 $(TRACE)='$$(warning TRACE $(TRACE))$(shell $(MAKE) TRACE=$(TRACE) _value)'

_value: 
	@echo '$(value $(TRACE))'
endif

