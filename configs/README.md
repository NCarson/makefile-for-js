 
## On installing global packages

If you love wasting disk space, stop reading now. If you think having
just one version of a basic command line utility is silly, this is not for
you. A picture is worth a thouand words: my very basic global setup: `/usr/lib/node_modules$ ls`
```
@babel             documentation         http-server       mustache
nunjucks      uglifyjs
ava                eslint                jsdoc             n
react-docgen  wilster-doc
browserify         eslint-plugin-import  json              npm
repl.history
bundle-phobia-cli  eslint-plugin-react   local-web-server  npm-check-updates
uglify-js
/usr/lib/node_modules$ du -hsc  
741M    .
741M    total
```
For local intalls * disk totabl by amount of projects you have.
Every time you do something in npm it has to walk through all those files
to make sure the system is intact

If you try to install compile tools globally certain ones like BABEL 7 $#@#%$
like to put certain things in /usr/local which makes them unreachable on
standard configs.

`npm config list
; node bin location = /usr/local/bin/node`

To fix maybe:
`npm config set prefix /usr`

Now everything has to go to the same direc (maybe).
