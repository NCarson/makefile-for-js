make[1]: Entering directory '/home/lukehand/src/js/test/makefile-for-js'

#project.makefile 
###Project Management makefile 
- Installs package directory configs and directory skeleton. 
- Installs npm compile tools. 
- handles version control of local makefiles. 
#common.makefile 
###Common makefile library 
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
####Watch out with spaces when setting variables. 
Make is very literal in setting things. 
BAD: `DIR_BASE := .. \\n`# will evaluate to ..  
GOOD: `DIR_BASE := ..\\n`# will evaluate to .. 
So the value starts right after assingment symbol and ends at newline or comment hash. 
####Dont set variables with the environment 
The -e switch will push the whole environment in and who knows whats in there. 
Setting variables after the the make command will isolate and document what you are trying to do. 
BAD: `USE_THINGY=1 make -e`# set through environment 
GOOD: `make USE_THINGY=1`# set by make echo | echo cat
make[1]: Leaving directory '/home/lukehand/src/js/test/makefile-for-js'
make[1]: Entering directory '/home/lukehand/src/js/test/makefile-for-js'
#@ echo "$HELP_USE" echo '| echo cat'

###common.makefile 
    *Note:* because of technically difficulity in mdless: USE MDLESS should be USE_MDLESS and so on.
 
**USE MDLESS**: use mdless command to form command line markdown output 
     https://brettterpstra.com/2015/08/21/mdless-better-markdown-in-terminal 
**USE COLOR**: colorize output echo | echo cat
make[1]: Leaving directory '/home/lukehand/src/js/test/makefile-for-js'
make[1]: Entering directory '/home/lukehand/src/js/test/makefile-for-js'

###common.makefile 

**help**: print this message 

**printall**: print all public type variables (no underscore; defined in file or command line or environment override) 

**printall-raw**: print all variables and values known to make 

**print-%**: print-varname - prints the value of varname 

**help-use**: print USE_VARNAME type help 

**help-file**: print help for makefile 
###project.makefile 

**all**: runs files and npm-install rules 

**files**: install new files from `DIR_PRJ_ROOT` 

**clean**: removes files that were added by all rule using the manifset file in `DIR_CACHE` 

**npm-install**: install compile plugins locally 

**npm-install-global**: installs compile tools globaly for command line usage 

**diffs**: make diff files if needed from MANIFEST files 
    Uses `git merge-file <current-file> <base-file> <other-file>` where 
    where current is your local file; base-file is the original repo file from `make install`; 
    and other-file is the new repo file. If there is difference will create a file named 
    your-file.diff. It is up to the caller to merge the difference by hand. After 
    edits are finished and integerated into your source (FIXME see FILE_COMMIT)\ reinstall files to get a new commit hash. 

**.makefilejs/COMMIT**: copys skeleton directory and git commit hash from `DIR_PRJ_ROOT` 

**.makefilejs/MANIFEST**: record of files from skeleton directory in `DIR_PRJ_ROOT` echo | echo cat
make[1]: Leaving directory '/home/lukehand/src/js/test/makefile-for-js'
