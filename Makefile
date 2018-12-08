
SUBDIRS := src/umd src/codesplit src template
.PHONY: all clean repo $(SUBDIRS)

print-%:
	@ echo '$*=$($*)'

all: $(SUBDIRS)

#writing all like this makes it parallelizable!
$(SUBDIRS):
	$(MAKE) -C $@

# and this guards that template will only built
# after the source direcs
template: src src/umd src/codesplit


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
create-../%:
	mkdir -p ../$*/$(PUBLIC) ../$*/$(SRC) ../$*/$(TEMPLATE)
	cp -n src/Makefile ../$*/$(SRC)
	cp -n template/Makefile template/index.mustache ../$*/$(TEMPLATE)
	cp -n config.dev.js config.prod.js ../$*
	cp -n .stub.package.json ../$*/package.json
	cp -n .conf.makefile .js.makefile .css.makefile .template.makefile ../$*
	
# copy makefile includes to ../direc
update-../%:
	cp .conf.makefile .js.makefile .css.makefile .template.makefile ../$*

test-../%: 
	cp .eslintrc.js ../$*
	cp src/.*.css src/*.js ../$*/$(SRC)
	rm ../$*/$(SRC)/config.js
	cd ../$* && npm i
	cd ../$* && npm i node-emoji
	cd ../$*/$(SRC) && make
