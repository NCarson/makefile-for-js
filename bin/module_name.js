#!/usr/bin/node

const fs = require('fs')
const {nodePaths} = require("./lib")
const program = require('commander')

var argFiles
program
    .description('transform node_module path to package name')
    .arguments('[files...]')
    .action( (files) => argFiles = files)
    .option('--stdin', 'read from pipe or stdin') //NODE is GAY https://github.com/nodejs/node-v0.x-archive/issues/7412
program.parse(process.argv)


if (program.opts().stdin) {
    var argFiles = fs.readFileSync(0, 'utf-8');
    argFiles = argFiles.split(' ')
}

const depends = nodePaths(argFiles)
process.stdout.write(Array.from(depends).join('\n'))
process.stdout.write('\n' )
