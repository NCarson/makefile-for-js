# Makefile for JavaScript

## *Make only what you need.*

<img 
    alt='screenshot' 
    src='https://raw.githubusercontent.com/NCarson/makefile-for-js-js/master/.screen.png'
    width='600' />

- implicit rules for making JS files (like how you type `make` in C source and it compiles)
- Easy to modify and extend to different needs.
- Nice, 'modern' makefile syntax. Easy to use. self documenting. Well commented.

## JS transpile Features

* Easy to read colorized output.
* Knows how to 'do the right thing' for average cases.
* Supports parallel builds out of the box: `make --jobs=4`.
* Automatically splits bundle and vendor.
* Supports code splitting.
* Supports UMD builds for libraries.
* Supports `babel` and `eslint`.
* Supports gzipped and minimized targets.
* Supports development and production modes.

### Toolchain
- babel
- browserify
- eslint
- uglify-js
- madge

## Try it Out

```shell
mkdir test && cd test
npm init --yes
npm install makefile-for-js
npx makefile-project > Makefile # root project Makefile
make npm-install # will install compile dev tool packages
mkdir src && cd src
npx makefile-js > Makefile # src code Makefile
touch test.js
make 
```
Default will create `PRJ_ROOT/public/dist/vendor.js` and `PRJ_ROOT/public/dist/bundle.js`.

## Features

- **dependency chain** After running `make` once try `touch hello.js && make`
  Notice that not as many files were rebuilt. The `vendor.js` bundle is only remade
  when you remake all the sources or package-lock.json is updated. Try adding
  `hello2.js`. `hello.js` Is already transpiled as `build/hello.js`. So makefile 
  only needs to transpile hello2.js for the bundle. Everything is build
  'smartly' like this where only the changes in the dependencies need to be
  rebuilt. If you keep most of your code in vendor your build times should be quite
  fast.

- **USE vars** There a lots of switches to customize generation. Perhaps you dont need babel,
  then you could add `USE_BABEL :=` in the Makefile so it would not transpile.
  You could also set it the command line for a one off like: `make USE\_BABEL=`
  (notice this is set after the make command. DONT DO `USE_BABEL= make` as the
  variable does not respect the environment. You could see all the `USE\_*` type 
  settings with `make help-use`. You can check the default setting for USE\_BABEL
  with `make print-USE_BABEL`.

- **make printall** All important variables are shown with `make printall`. It does not show
  variables prepended with \_, automatic, environment, help stuff, or built in kinds.
  These variables are set up to be changed as part of a 'public interface'. They
  use a type of Hungarian notion such as FILE\_\*, FILES\_\*, DIR\_\*, CMD\_\*, CMD\_\*\_OPTIONS. 
  This will give you and idea of important files and commands that are necessary
  for the makefile. All commands not part of basic shell commands (such as `ls` or `echo`)
  will be listed in `make printall`. If you really want to see all variables you
  can use `make printall-raw`.

- **targets** default setup will make `PROJECT_ROOT/public/dist/bundle.js` and `PROJECT_ROOT/public/vendor.js`

- **defaults** Code gen defaults to - eslinted, babelized ES5, minified in production, inline source maps in development, gzipped
