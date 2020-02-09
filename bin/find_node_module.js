#!/usr/bin/node

const {getNodeModule} = require("./lib")
const program = require('commander')

var argDirectory
program
    .arguments('[directory]')
    .action( (directory) => argDirectory = directory)
    .option('--strip-node', 'path with node_module part removed')
program.parse(process.argv)

const options = {}
if (argDirectory)
    options.cwd = argDirectory
if (program.opts().stripNode) 
    options.stripNode = true
const result = getNodeModule(options)
if (result === undefined)
    process.exit(1)
process.stdout.write(result + '\n' )
