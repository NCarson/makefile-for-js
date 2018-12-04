
## *Make only what you need.*

### Features

* Knows how to 'do the right thing' for regular js files.
* Automatically splits bundle and vendor.
* Supports code splitting.
* Supports UMD Builds for libraries.
* Supports templating with Mustache out of the box (or whatever engine you want).
* Supports keeping css next to the source files.
* Support for linters.
* Support for babel.
* Supports gzipped and minimized targets.
* Can be modified to support any toolchain
* Build configs are isolated by directory
* Supports devolpment and production modes

### Important Files

You should glance through these to understand the process.
The Makefiles are the most important as they show 

* conf.makefile - This file is used to config js.makefile.
* js.makefile - This file has the rules for compiling.
* Makefile - example stubbed to see how to use the main project Makefile.
* src/Makefile - example of regular project
* src/codesplit/Makefile - example of code splitting
* src/umd/Makefile - example of how to get a library build ready for npm
* srt/template/Makefile - example of an index.html using Mustache
* config.dev.js / config.prod.js 

    These will be available in the build dir as config.js depending on the 
    environment e.g. `make` or `PRODUCTION=1 make`.
    
### Install

#### Linux Debian/Ubuntu (easy peasy):

* Must:

   `sudo apt-get install make`
   Npm commands all have the **-g** flag as this a command line tool.
   `npm install -g browserify`:w

* Optional but you probably want it unless you heart ES5:

    `npm install -g babel`
    You will still need presests in your dev-dependicies such as `babel-preset-es2015`.

* Optional for templating:

    (you could diverge from this but you have to change conf.makefile)
    `npm install -g mostache`
    `npm install -g json`

#### Windows (Maybe, I've never tried):

    Get the GNU UTILS for powershell.  Get npm and follow the same the commands as above.

#### Other \*Nix (Should):

    Figure out how install packages for your \*nix and get `make`.
    It has to be `GNU make`, not other makes.
    Install npm and npm packages as above.
    Other command line chain is probably OK.

### Quickstart
Make the example project:
```shell
make # development
PRODUCTION=1 make # production
```

### Minimal Example
Makefile
```make
BASE_DIR := ./
include conf.$(MAKE)file
.PHONY: all clean
all: 
    cd src && $(MAKE)
clean: clean-gz
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
is underneath another src directory add `EXCL_SRC_DIRS := ./codesplit `
to the parent code Makefile.

### UMD build

See src/umd/Makefile. Crazy easy.  Instead of `BUNDLE_BASENAME` set `UMD_BASENAME`
then: `TARGETS := $(TARGET_DIR)/$(UMD_BASENAME).min.js`. If you use it from a
cdn it will availabe as `window.UMD_BASENAME`

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



