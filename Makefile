# in case these actually exist as files `make` would be confused without .PHONY
.PHONY: all clean repo

# The first rule in a makefile is the default if you just type `make`.
# Traditionally is called all
all:
	cd src/umd && $(MAKE)
	cd src/codesplit && $(MAKE)
	cd src && $(MAKE)
	cd template && $(MAKE)

# rm all build files and start fresh
clean:
	cd src && $(MAKE) clean
	cd src/codesplit && $(MAKE) clean
	cd src/umd && $(MAKE) clean
	cd template && $(MAKE) clean


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
	

