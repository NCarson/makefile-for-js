
# mixed recursive and immediate
https://blog.jgc.org/2016/07/lazy-gnu-make-variables.html
https://www.cmcrossroads.com/article/painless-non-recursive-make

## Disclaimer:

I may or may not have been highly intoxicated while I wote this manual
to become a Sholin Monk. It is highly opienated and may even contain slightly
misognistic viewpoints.

## Preamble:

OMG Ponies! But I hate ponies so I am here to talk about GNU Make. That thing that
those GNUy guys did long long ago in a far off place called 'GNU is not Unix' ... 
The first thing to know about make is that great-grandpa used to do it while he
was taming the inter-webs. It actually predates C; Cuz would he (and back then
it was HISstory) just keeping typing `cc this.c` `cc that.c` `link this and that`
until you fingers fell off. 
No silly, he would build some automatic tool to keep typing this in for him. So
Make was borne. And, it was quite an unholy child...
Although I **do** hold these truth be self evident a wise man once said: The big
print giveth and small print taketh away ... so read on young grashoppers

## How to become a Shoulon Monk of GNU Make in 3 easy steps: Become Beginner, Become Intermediate, Become Advanced.

wax on, wax off, young grasshopper ...

## Beginner 

- know shell commands
    make is but a thin wrapper for executing shell commands for certain
    conditions. You could know the make program through and through but if you
    do not know basic shell commands you will become truly lost, as 
    they are verbs of a Makefile. (And, this is why most young grasshoppers
    fail. Quit now weeklings.)

- make is two things into one.
    If I was a make then I would: First, read all the things that do not start with TAB. From rules generated
    by first thing execute TAB parts with SHELL commands. So, TL;DR two
    languages for the price of one (and maybe not in a good way?).

- one TAB; not four spaces!
    Makefiles are parsed in two parts. Everything with a tab is assumed
    a shell command and will be executed in the second parsing when a rule
    matches.  The executed rules must have a tab; four spaces will become an error.

- Think from the top to bottom
    When makefile get sad and it tells you 'But I don know how to make', you usually
    have a broken chain of dependencies. Humans: `*.c -> *.o -> mySuperSweetProgram`
    Makefile: `mySuperSweetProgram -> *.o -> *.c`. Subtle yet powerfull.

- Big Phonies
    Know what `.PHONY: blah ha` means. You will be surpised how often your unusual
    name will actually be a file.

## Intermediate

- start sanity checking things
    make does not care if variables has been defined or not. It just evualates to
    an empty string.

- know the difference between = and :=
    In tradiational languages you would say the first is a function and the second a constant.

- know what ?= and ?+ does
    ?= gives the caller a chance to override the variable: `MYVAR=2 make`.
    If MYVAR is set with = or := it is wiped out. With ?= or ?+ it only sets it
    if was unset and perhaps empty in the environment.

- dont touch things in the rule execution to signify that a prereq needs to be updated.
    Bad, Bad dog. It might work if you are willing to run make twice. If you
    are experiencing this behavier and dont understand it you may be unknowingly
    changing last-mod time while the rules are executing. (Make checks the times
    in the first parse not the second.)

## Advanced

- mkdir -p

- figure out that after pains takenly created a very correct dependency graph. 

- learn how to include files so you can keep your sanity.

- learn the print-% debug trick:

- learn the right way to execute different makefiles in parallel

- learn second-order rules

- dont use .SECONDEXPENSION
    Great grandpa did not have a second expansion and he built the internet.
    Your doing it wrong if you use it. (If you dont know what a second expansion
    is, good! Keep it that way. You dont need it.)

- Using pattern rules to enforce atomic rules

    GNU Make does have a way to build more than one target in a single rule using a
    pattern rule.  Pattern rules can have an arbitrary number of target patterns and
    will still be treated as a single rule.
    https://www.cmcrossroads.com/article/atomic-rules-gnu-make

- pattern specific locally scoped variables
    `lib1/%.o: CPPFLAGS += -fast`.  will last for rule and prereq children.
    https://www.cmcrossroads.com/article/target-specific-and-pattern-specific-gnu-make-macros

- using content-hashes instead of last-modified time stamps
    `git hash-oject`
    https://www.cmcrossroads.com/article/rebuilding-when-files-checksum-changes
- 

