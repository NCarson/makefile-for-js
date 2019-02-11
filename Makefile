
SUBDIRS := src/umd src/codesplit src template 
.PHONY: all clean $(SUBDIRS) publish

print-%:
	@ echo '$*=$($*)'

all: $(SUBDIRS)

#writing `all:` like this makes it parallelizable!
$(SUBDIRS):
	$(MAKE) -C $@

# and this guards that template will only built
# after the source direcs
template: src src/umd src/codesplit

publish: clean
	cd src && $(MAKE)
	cd src/codesplit && $(MAKE)
	cd src/umd && $(MAKE)
	npm version patch
	git push --tags
	npm publish

# rm all build files and start fresh
clean:
	cd src && $(MAKE) clean
	cd src/codesplit && $(MAKE) clean
	cd src/umd && $(MAKE) clean
	cd template && $(MAKE) clean

TEMPLATE := template
PUBLIC := public
SRC := src


# copy files to start new project in ../direc
create-../%: FORCE
	mkdir -p ../$*/$(PUBLIC) ../$*/$(SRC) ../$*/$(TEMPLATE)
	cp -n src/Makefile ../$*/$(SRC)
	cp -n template/Makefile template/index.mustache ../$*/$(TEMPLATE)
	cp -n config.dev.js config.prod.js ../$*
	cp -n .stub.package.json ../$*/package.json
	mkdir -p ../$*/.makefiles
	cp -n .makefiles/* ../$*/.makefiles/
	
# copy makefile includes to ../direc
update-../%: FORCE
	mkdir -p ../$*/.makefiles
	cp .makefiles/* ../$*/.makefiles

test-../%: FORCE
	cp .eslintrc.js ../$*
	cp .makefiles/* ../$*/
	rm ../$*/$(SRC)/config.js
	cd ../$* && npm i
	cd ../$* && npm i node-emoji
	cd ../$*/$(SRC) && make

FORCE:

