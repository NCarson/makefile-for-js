#!/usr/bin/node

TARGET = 'test.makefile'

const program = require('commander')
const fs = require('fs')
const { write } = require('./lib')
const { getNodeModule } = require('./lib')
const { writeOptions } = require('./lib')

program
    .description('Toplevel makefile for testing.')
//.option('--kind <bundle | umd>', 'bundle or umd library type build', 'bundle')
//
program.parse(process.argv)

const newOpts = { 'DIR_PRJ_ROOT': getNodeModule({stripNode:true}) || '.'}
writeOptions('MAKEFILE-TEST', newOpts)
write(TARGET)
