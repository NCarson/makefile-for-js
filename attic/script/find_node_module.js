#!/usr/bin/node
'use strict';

//https://github.com/callumacrae/find-node-modules

var path = require('path');
var findup = require('findup-sync');
var merge = require('merge');

/**
 * Finds all parents node_modules directories and returns them in an array.
 *
 * @param {object} options An object containing objects. Read the readme or
 *                         the source code.
 */
function findNodeModules(options) {
	if (typeof options === 'string') {
		options = {
			cwd: options
		};
	}

	options = merge({
		cwd: process.cwd(), // The directory to start the search from
		searchFor: 'node_modules', // I see no reason to change this
		relative: true // If false, returns absolute paths
	}, options);

	var modulesArray = [];
	var searchDir = options.cwd;
	var modulesDir;
	var duplicateFound = false;

	do {
		modulesDir = findup(options.searchFor, { cwd: searchDir });

		if (modulesDir !== null) {
			var foundModulesDir = formatPath(modulesDir, options);
			duplicateFound = (modulesArray.indexOf(foundModulesDir) > -1);
			if (!duplicateFound) {
				modulesArray.push(foundModulesDir);
				searchDir = path.join(modulesDir, '../../');
			}
		}
	} while (modulesDir && !duplicateFound);

	return modulesArray;
};

/**
 * Internal function to return either a relative or an absolute path depending
 * on an option. Basically not very useful, could be inline.
 *
 * @param {string} modulesDir The absolute path
 * @param {object} options Options object containing relative boolean and cwd
 * @returns {string} Either an absolute path or a relative path
 * @private
 */
function formatPath(modulesDir, options) {
	if (options.relative) {
		return path.relative(options.cwd, modulesDir);
	} else {
		return modulesDir;
	}
}

/********************* mine **********/

const program = require('commander')
var argDirectory

program
    .arguments('[directory]')
    .action( (directory) => argDirectory = directory)
program.parse(process.argv)

const options = {}
if (argDirectory)
    options.cwd = argDirectory

const result = findNodeModules(options)
if (result.length  == 0)
    process.exit(1)

process.stdout.write(result[0].toString() + '\n' )



