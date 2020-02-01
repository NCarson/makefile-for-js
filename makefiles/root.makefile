all:
	cd src && make

example:
	cd example && make

clean:
	cd src && make clean

docs:
	cd src && make docs

commit-doc:
	git add docs README.md
	git commit -m "updated doc"
	git push

publish:
	cd src && make clean
	cd src && PRODUCTION=1 make
	cd src && make docs
	npm version patch
	npm publish
	git push --tags

GLOBAL_NPM_DIR := /usr/lib/node_modules#may be different like /usr/local/lib
npm-globalize:
	cd node_modules && ln -s -f $(GLOBAL_NPM_DIR)/@babel
	cd node_modules && ln -s -f $(GLOBAL_NPM_DIR)/babel-eslint
	cd node_modules && ln -s -f $(GLOBAL_NPM_DIR)/eslint-plugin-import
