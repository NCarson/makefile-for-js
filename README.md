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

### API Doc

https://ncarson.github.io/makefile-for-js/

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

### Quick Start Grok

- Make a new directory.
- Inside the direc run `git clone https://github.com/NCarson/makefile-for-js.git`.
- Run `cd makefile-for-js && make install`. This will copy `project.makefile`
  into the new directory.

- From the new directory, try `make -f project.makefile help.` This will give
  you the different top level targets it supports. All makefiles from this
  project support a common help interface. Also try help-use, help-file, help-extra,
  and printall. Browse `project.makefile`. All project makefiles have the same
  structure.

- Run `make -f project.makefile all`. This will install configs, directories,
  and compile packages that the makefiles use.

- In `./src`, run `make`. Also try out the help commands. Maybe add a toy `hello.js`.
  New files are picked up automatically and will rebuild necessary files.

- Notice that once you `git init` your project, makefile-for-js you will become a sub-git.
  You may want to fork it to customize your workflow. As time goes on your
  configs evolve and so do the repo ones. You can use `make -f project.makefile
  diffs` To write diffs between your file and the config files with the original
  commit as the reference file. Once you are happy with your merges run `make -f
  project.makefile install` again to update the commit reference.

- There a lots of switches to customize generation. Perhaps you dont need babel,
  then you could add `USE_BABEL :=` in the Makefile so it would not transpile.
  You could also set it the command line for a one off like: `make USE\_BABEL=`
  (notice this is set after the make command. DONT DO `USE_BABEL= make` as the
  variable does not respect the environment. You could see all the `USE\_*` type 
  settings with `make help-use`. You can check the default setting for USE\_BABEL
  with `make print-USE_BABEL`.

- All important variables are shown with `make printall`. It does not show
  variables prepended with \_, automatic, environment, help stuff, or built in kinds.
  These variables are set up to be changed as part of a 'public interface'. They
  use a type of Hungarian notion such as FILE\_\*, FILES\_\*, DIR\_\*, CMD\_\*, CMD\_\*\_OPTIONS. 
  This will give you and idea of important files and commands that are necessary
  for the makefile. All commands not part of basic shell commands (such as `ls` or `echo`)
  will be listed in `make printall`. If you really want to see all variables you
  can use `make printall-raw`.

- default setup will make `PROJECT_ROOT/public/dist/bundle.js` and `PROJECT_ROOT/public/vendor.js`

- Code gen defaults to - eslinted, babelized ES5, minified in production, inline source maps in development, gzipped


**A Picture Is Worth a Thousand Words ...**

<img src="./.dot-graph.svg" width=800>
