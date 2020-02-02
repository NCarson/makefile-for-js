
GLOBAL_NPM_DIR := /usr/lib/node_modules#may be different like /usr/local/lib
GLOBAL_PACKAGES := \
	@babel/cli  \
	@babel/plugin-proposal-class-properties \
	@babel/plugin-transform-object-assign \
	@babel/preset-env \
	@babel/core \
	@babel/plugin-syntax-dynamic-import \
	@babel/plugin-transform-react-jsx \
	@babel/preset-react \
	babel-eslint \
	eslint-plugin-import \
	eslint-plugin-react \
	browserify-global-shim \

HELP += install: install global npm packages (see GLOBAL_PACKAGES) as root
install:
	sudo npm i -g $(GLOBAL_PACKAGES)

NPM_COMMAND := npm link 
# XXX note that `npm link (developers)` are way too stupid to use absolute
#     directories with the soft links, so if you move your package you may have rerun.
# TODO make script to make links right way (scoped packages need a real directory). see above

HELP += link-global: create sym links in local `node_modules` so global packes will be found
link-global:
	npm link $(GLOBAL_PACKAGES)

HELP += unlink-global undo link-global
unlink-global:
	cd node_modules && rm $(GLOBAL_PACKAGES)
