
# Makefile for JavaScript

## *Make only what you need.*

### Features

* Knows how to 'do the right thing' for average cases.
* Automatically splits bundle and vendor.
* Supports code splitting.
* Supports UMD Builds for libraries (aka ... but how do you publish to NPM?).
* Supports templating with Mustache out of the box (or whatever engine you want).
* Supports keeping css next to the source files (or whatever you want).
* Support for linters (or just dont).
* Support for babel (but you might just love ES5).
* Supports gzipped and minimized targets (But you dont have to).
* Can be modified to support any toolchain
* Build configs are isolated by directory
* Supports development and production modes
* Language independent
* Easy to read colorized colorized output

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

* [Makefile](/NCarson/makefile-for-js/blob/master/Makefile)
 - example stubbed to see how to use the main project Makefile.

* [src/Makefile](/NCarson/makefile-for-js/blob/master/src/Makefile)
 - example of regular project

* [src/codesplit/Makefile](/NCarson/makefile-for-js/blob/master/src/codesplit/Makefile)
 - example of code splitting

* [src/umd/Makefile](/NCarson/makefile-for-js/blob/master/src/umd/Makefile)
 - example of how to get a library build ready for npm

* [src/template/Makefile](/NCarson/makefile-for-js/blob/master/src/template/Makefile)
 - example of an index.html using Mustache

*  [config.dev.js](/NCarson/makefile-for-js/blob/master/src/config.dev.js)
 / [config.prod.js](/NCarson/makefile-for-js/blob/master/src/config.prod.js)

    These will be available in the build dir as config.js depending on the 
    environment e.g. `make` or `PRODUCTION=1 make`.

* [.conf.makefile](/NCarson/makefile-for-js/blob/master/src/conf.makefile)
 - This file is used to config js.makefile.
* [.js.makefile](/NCarson/makefile-for-js/blob/master/src/conf.makefile)
 - This file has the rules for compiling.
    
### Install

#### Linux Debian/Ubuntu (easy peasy):

* Must:

   `sudo apt-get install make`
   npm install command must have the **-g** flag as this a command line tool.
   `sudo npm install -g browserify`

* Optional but you probably want it unless you heart ES5 or survive on poly-fill
  (If you dont know what that meant definitely install.):

    `sudo npm install -g babel`
    You will still need presets in your dev-dependicies such as `babel-preset-es2015`.

* Optional for out of the box templating:

    `sudo npm install -g mustache json`

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
Read over `conf.makefile` and look at the default configs.

**Now for your project ...**

```shell
make dist-clean
git init
npm init
```

Change `conf.makefile` if you need to. Setup your src directory.
The example Makefiles will be in the directory for reference.
Maybe fork this git and make it just how you want.
*Happy Coding ...*

### Minimal Example
Makefile
```make
BASE_DIR := ./
include conf.$(MAKE)file
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
include $(BASE_DIR)/js.makefile
clean:
	rm -f $(TARGETS)
	rm -fr $(BUILD_DIR)
```

### Code split

Just start another directory with the Makefile filled in :).
Then call make on it from the root Project Makefile. If the codesplit
is underneath another src directory add `EXCL_SRC_DIRS := ./your_code_split_direc`
to the parent code Makefile.

### UMD build

See src/umd/Makefile. Crazy easy.  Instead of `BUNDLE_BASENAME` set `UMD_BASENAME`
then: `TARGETS := $(TARGET_DIR)/$(UMD_BASENAME).min.js`. If you use it from a
cdn it will availabe as `window.UMD_BASENAME`

See https://unpkg.com/makefile-for-js-example@0.0.1/ for what the example builds.

### CSS

See src/test2.js and src/.test2.css. CSS will be available 
in /public/dist/main.css according to above config.

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



