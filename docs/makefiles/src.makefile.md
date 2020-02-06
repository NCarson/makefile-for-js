-e 
# src.makefile.md


`src.makefile` 

### JS Source Code Management. 
Manages bundle builds for javascript files. 
 
run `make help` see top level non-pattern rules 
run `make` development 
run `make PRODUCTION=1` production production mode (minified) aka NODE_ENV=production  

`common.makefile` 
### Common Makefile Library 
Base makefile library 
This is included from a top level makefile.  

`js.makefile` 

### Java Script Transpile Makefile Compiles .js sources through chain of linting, transpiling, bundling, minifing, and zipping. 
run `make -f PROJECT_ROOT/makefiles-for-js/makefiles/js.makefile -p` to print out rules of the js makefile
-e 
# TARGETS


.DEFAULT_GOAL = all 


`common.makefile` 

**help**: print this message 

**printall**: print all public type variables (no underscore; defined in file or command line or environment override) 

**printall-raw**: print all variables and values known to make 

**print-%**: print-varname - prints the value of varname 

**help-use**: print USE_VARNAME type help 

**help-file**: print help for makefile 

**help-extra**: print extra help 

`js.makefile` 

**phobia-cdn**: Show how much space you are saving in excluded libs 

**list-deps**: Show local dependencies. 

**phobia-deps**: List package dependencies from bundle-phobia. 
     "sudo npm i -g bundle-phobia" 

**dot-graph**: Create a dependency graph of targets. 
    needs makefile2graph https://github.com/lindenb/makefile2graph) 

`src.makefile` 

**all**: Make the `TARGETS`. 

**clean**: Remove `TARGETS` and `DIR_BUILD`.
-e 
# USE VARIABLES


`common.makefile` 

*Because of technically difficulity in mdless: USE MDLESS should be USE_MDLESS and so on.* 
**USE MDLESS**: use [mdless](https://github.com/ttscoff/mdless) command to form command line markdown output  
**USE COLOR**: colorize output 

`js.makefile` 

**USE PRODUCTION**: If set then use production options instead of development. 
    Also will be set if NODE_ENV=production in the environment. 

**USE BABEL**: transpile with babel 

**USE LINTER**: use eslint 

**USE SOURCEMAPS**: bundle source maps for debugging 

**USE REACT**: set transform flags for react 

**POST US6**: babel transform for static class props and object spreads
-e 
# EXTRA HELP


`common.makefile` 
 
run `make help` see top level non-pattern rules 
run `make help-file` help for each included file 
run `make help-use` help for USE_\% type variables 
run `make -j 8` to run with 8 threads in paralell (set the number to number of cores)! 
run `make -n` for a dry run that will print out the actually commands it would have used 
run `make --trace` to see all recipe shell commands 
run `make --debug=b` basic debug dependency chain 
#### Dont set bool type variables to zero. 
BAD: `USE_THINGY :=0` 
GOOD: `USE_THINGY :=` 
This is because make usually checks for existance of variable being set. 
#### Watch out with spaces when setting variables. 
Make is very literal in setting things. 
BAD: `DIR_BASE := .. \\n`# will evaluate to ..  
GOOD: `DIR_BASE := ..\\n`# will evaluate to .. 
So the value starts right after assingment symbol and ends at newline or comment hash. 
#### Dont set variables with the environment 
The -e switch will push the whole environment in and who knows whats in there. 
Setting variables after the the make command will isolate and document what you are trying to do. 
BAD: `USE_THINGY=1 make -e`# set through environment 
GOOD: `make USE_THINGY=1`# set by make 
Unsetting variables on the command line 
GOOD: `make USE_THINGY=`