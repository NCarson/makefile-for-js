
CMD_NPM := npm
CMD_GIT := git

.DEFAULT_GOAL := all
HELP +=\n\n**all**: make all sub makes
export HELP
.PHONY: help
all:
	$(MAKE) -C src

HELP +=\n\n**clean**: clean all sub makes
clean:
	$(MAKE) -C src clean

HELP +=\n\n**publish**: publish package to npm registery

publish:
	#$(MAKE) -C src USE_PRODUCTION=1
	$(CMD_GIT) add .
	$(CMD_GIT) commit; 
	$(CMD_NPM) version patch
	$(CMD_NPM) publish
	$(CMD_GIT) push --tags

#TODO add separate makefile for documentation
#docs:
#	cd src && make docs
#
#commit-doc:
#	git add docs README.md
#	git commit -m "updated doc"
#	git push


