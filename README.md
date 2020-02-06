# Makefile for JavaScript

## *Make only what you need.*

<img 
    alt='screenshot' 
    src='https://raw.githubusercontent.com/NCarson/makefile-for-js/master/.screen.png'
    width='600' />

- implicit rules for making JS files (like how you type `make` in C source and it compiles)
- Management of project template configs and directory structure
- Easy to modify to different needs.
- Easy to use. self documenting. Well commented.

### Quick Start

- Make a new directory.
- Inside of it, clone this repo.
- Run `cp makefile-for-js/makefiles/project.makefile`.
- If its your first time run `make -f project.makefile npm-install-global` #FIXME add local install.
- Run `make -f project.makefile all`.
- Put your sources in `src`
- Install npm packages you need for the source .
- In `./src`, run `make`
- default setup will make `PROJECT_ROOT/public/dist/bundle.js` and `PROJECT_ROOT/public/vendor.js`
- Code gen defaults to - eslinted, babelized ES5, minified in production, inline source maps in development, gzipped

### JS transpile Features

* Easy to read colorized output.
* Knows how to 'do the right thing' for average cases.
* Supports parallel builds out of the box: `make --jobs=4`.
* Automatically splits bundle and vendor.
* Supports code splitting.
* Supports UMD Builds for libraries.
* Supports babel and eslint.
* Supports gzipped and minimized targets.
* Supports development and production modes.

### Project Management

* Mirrors project directory repo. see `makefile-for-js/project-skel/vanilla`
* Creates diff files for fixing conflicts in repo config file changes.
* installs skeleton npm packages

**A Picture Is Worth a Thousand Words ...**

<img src="./.dot-graph.svg" width=800>
