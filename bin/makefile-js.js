#!/usr/bin/node

const program = require('commander')
const fs = require('fs')
const { getNodeModule } = require('./lib')
const { write } = require('./lib')
const { writeOptions } = require('./lib')

program
    .arguments('[filename]')
    .action( (filename) => argFilename = filename)
    .description('output makefile for JS source transpiling.')
    .option('--kind <bundle | umd>', 'bundle or umd library type build', 'bundle')
    .option('--no-babel', 'do not transpile with babel')
    .option('--no-source-maps', 'dont use source maps in development')
    .option('--react', 'use react options', false)
    .option('--linter', 'do not lint check with eslint', false)
    .option('--post-es6', 'dont use post es6 features, like object spread', false)

program.parse(process.argv)
const opts = program.opts()

kind = opts.kind
if (kind === 'bundle')
    ROOT = 'bundle'
else if (kind === 'umd')
    ROOT = 'umd'
else {
    console.error("unsupported option --kind=" + kind)
    console.error(program.help())
    process.exit(1)
}

function use(bool) {return bool ? '1' : '' }
const newOpts = {
    'DIR_PRJ_ROOT': getNodeModule({stripNode:true}) || '.',
    'USE_REACT': use(opts.react),
    'USE_BABEL': use(opts.babel),
    'USE_LINTER': use(opts.linter),
    'USE_SOURCE_MAPS': use(opts.sourceMaps),
    'USE_POST_ES6': use(opts.postEs6),
}
writeOptions('MAKEFILE-JS', newOpts)


TARGET = ROOT + '.makefile'
//write(TARGET)
