
# Makefile for JavaScript

## *Make only what you need.*

<img 
    alt='screenshot' 
    src='https://raw.githubusercontent.com/NCarson/makefile-for-js/master/.screen.png'
    width='300' />

### Features

* Knows how to 'do the right thing' for average cases.
* Automatically splits bundle and vendor.
* Supports code splitting.
* Supports UMD Builds for libraries.
* Supports templating with Mustache out of the box (or whatever engine you want).
* Supports keeping css next to the source files.
* Support for linters.
* Support for babel.
* Supports gzipped and minimized targets.
* Can be modified to support any toolchain.
* Build configs are isolated by directory.
* Supports development and production modes.
* Is language independent.
* Has easy to read colorized output.

So ... super-fast builds ... not so much config.

### Important Files

This is a template not a build system. The defaults should 
handle average use cases but you do need to know just a little 
about GNU make. If your like me, you like to shoot first and 
read the manual later. So, I've set up a fake project that 
you can muck around in get the vibe of how it works.

You should glance through these to understand the process.
The `Makefile`s are the most important for beginners. The first
two being the most important and basic.

* [Makefile](https://github.com/NCarson/makefile-for-js/blob/master/Makefile) - 
example stubbed to see how to use the main project Makefile.
https://github.com/NCarson/makefile-for-js/blob/master/Makefile
* [src/Makefile](https://github.com/NCarson/makefile-for-js/blob/master/src/Makefile) - 
example of regular project
* [src/codesplit/Makefile](https://github.com/NCarson/makefile-for-js/blob/master/src/codesplit/Makefile) - 
example of code splitting
* [src/umd/Makefile](https://github.com/NCarson/makefile-for-js/blob/master/src/umd/Makefile) - 
example of how to get a library build ready for npm
* [src/template/Makefile](https://github.com/NCarson/makefile-for-js/blob/master/src/template/Makefile) - 
example of an index.html using Mustache
*  [config.dev.js](https://github.com/NCarson/makefile-for-js/blob/master/config.dev.js)
 / [config.prod.js](https://github.com/NCarson/makefile-for-js/blob/master/config.prod.js)

    These will be available in the build dir as config.js depending on the 
    environment e.g. `make` or `PRODUCTION=1 make`.
* [.conf.makefile](https://github.com/NCarson/makefile-for-js/blob/master/.conf.makefile) - 
This file is used to config js.makefile.
* [.js.makefile](https://github.com/NCarson/makefile-for-js/blob/master/.js.makefile) - 
This file has the rules for compiling.
    
### Install

#### Linux:
* Make sure you have GNU makefile. Ubuntu/Debian: `sudo apt-get install make`
* core: `sudo npm install -g browserify uglify`
* optional for ES6 (if your not sure you want it): `sudo npm install -g babel-cli` 
You will still need presets in your dev-dependicies such as `babel-preset-es2015`.
* optional templating: `sudo npm install -g mustache json`
* optional linting: `sudo npm install -g eslint`
* optional for using bundle-phobia `sudo npm install -g bundle-phobia`

#### Windows (Maybe, I've never tried):

(If you try open up a issue so I know it is possible or not.)
Get the GNU UTILS for powershell.  Get npm and follow the same the commands as above.

#### Other \*Nix (Should, never tried):

(If you get this to work open up a issue with type of \*nix so I know it is possible.)

Figure out how install packages for your \*nix and get `make`.
It has to be *GNU make*, not other makes (I think other makes have died off
but not completely sure).  Install npm and npm packages as above.
Other command line chain is probably OK (or not ;).

### Quickstart

**Make the example project:**

```shell
make # development
PRODUCTION=1 make # production
```
Notice you dont have to rebuild too much.

Read the makefiles and checkout the example website. Maybe ... `cd public && http-server`.
Read over `.conf.makefile` and look at the default configs.

**Now for your project ...**

```shell
make repo
cd repo
git init
npm init
```

Change `.conf.makefile` if you need to. Setup your src directory.
The example Makefiles will be in the directory for reference.
Maybe fork this git and make it just how you want.
*Happy Coding ...*

### Minimal Example
Makefile
```make
BASE_DIR := ./
include .conf.makefile
.PHONY: all clean
all: 
    cd src && $(MAKE)
clean:
	cd src && $(MAKE) clean
```

src/Makefile
```make
BASE_DIR := ../
VENDOR_BASENAME := vendor
BUNDLE_BASENAME := bundle
CSS_BASENAME := main
TARGET_DIR := $(BASE_DIR)/public/dist
TARGETS := $(TARGET_DIR)/$(BUNDLE_BASENAME).min.js \
		   $(TARGET_DIR)/$(BUNDLE_BASENAME).min.js.gz \
		   $(TARGET_DIR)/$(VENDOR_BASENAME).min.js \
		   $(TARGET_DIR)/$(VENDOR_BASENAME).min.js.gz \
		   $(TARGET_DIR)/$(CSS_BASENAME).min.css \
		   $(TARGET_DIR)/$(CSS_BASENAME).min.css.gz \
include $(BASE_DIR)/.js.makefile
clean:
	rm -f $(TARGETS)
	rm -fr $(BUILD_DIR)
```

### config.dev.js & config.prod.js

Normally make is in dev mode and links against config.dev.js
which will show up as `config.js` in your source directory. If
it is invoked with `PRODUCTION=1 make` `config.js` will be linked
against `config.prod.js`. 

Minifying files is ignored in dev mode,
so if you specify a file named `bundle.js.min` you will get one
but it will just be a copy of `bundle.js`. This makes it easy to link
to just one file in your html. 

Source maps are enabled in dev and not in prod.

### Code Splitting

Just start another directory with the Makefile filled in :).
Then call make on it from the root Project Makefile. If the codesplit
is underneath another src directory add `EXCL_SRC_DIRS := ./your_code_split_direc`
to the parent code Makefile.

### Building UMD type bundles

See src/umd/Makefile. Crazy easy.  Instead of `BUNDLE_BASENAME` set `UMD_BASENAME`
then: `TARGETS := $(TARGET_DIR)/$(UMD_BASENAME).min.js`. If you use it from a
cdn it will availabe as `window.UMD_BASENAME`

See https://unpkg.com/makefile-for-js-example@0.0.1/ for what the example builds.

### CSS

See `src/test2.js`.  If you have a file called widget.js
you can then have a file named widget.css in the same directory. CSS will be available 
in /public/dist/main.css according to above config. The sections will have their
filenames in comments. This way you can have your CSS close to the components
that need it. But, you don't have to recompile the module if you just change the
CSS. And, it will be a fast copy op instead of full recompile of the bundle.

### Templating
See .cdn\_libs, template/Makefile, template/index.mustache, and template/index.json.

Timestamps of the build time are available so you write hrefs like
/dist/vendor.js?123456. The next build will have a higher number. So you
can guarantee you will get a fresh version loaded in your browser without having to load
in other files. This can save a lot of time while devolping.

Cdn Libs are available under `cdns` if you have filled in .cdn\_libs
The format is:
`library\_name dev\_href production\_href`
or:
`library\_name production\_href` if no devolpment
library is available.
Example:
```
d3 https://unpkg.com/d3@5.7.0/dist/d3.min.js
```
In this example d3 is automatically not included in the vendor build
since it is listed in .cdn\_libs. index.json will now have the urls for cdn
libs but it is your responsibility to put them in the template.



