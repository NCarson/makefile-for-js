#!/usr/bin/node

const program = require('commander')
const { write } = require('./lib')
const { getNodeModule } = require('./lib')
const { writeOptions } = require('./lib')

TARGET = 'project.makefile'

program
    .description('output makefile for npm project administration.')
    .option('--global-compile', 'install compile tools globaly')
    .option('--global-plugin-compile', 'install compile plugin tools globaly')
program.parse(process.argv)

const opts = program.opts()
function use(bool) {return bool ? '1' : '' }
const newOpts = {
    'DIR_PRJ_ROOT': getNodeModule({stripNode:true}) || '.',
    'USE_GLOBAL_COMPILE': use(opts.globalCompile),
    'USE_GLOBAL_PLUGIN_COMPILE': use(opts.globalPluginCompile),
}
writeOptions('MAKEFILE-PROJECT', newOpts)
write(TARGET)

