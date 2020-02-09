const program = require('commander')
const fs = require('fs')
const findNodeModules = require('find-node-modules')

exports.writeOptions = function writeOptions(name, newOpts, file=process.stdout) {
    file.write(`#######################################\n`)
    file.write(`# ${name} OPTIONS \n`)
    file.write(`#######################################\n`)
    for (let key in newOpts) {
        file.write(`${key} :=${newOpts[key]}\n`)
    }
    file.write('\n')
}

exports.write = function write(name) {
    src = __dirname + '/../makefiles/' + TARGET
    process.stdout.write(fs.readFileSync(src))
    process.stdout.write('\n')
}

exports.getNodeModule = function getNodeModule(options) {
    var result = findNodeModules(options)
    if (result.length === 0)
        return undefined

    if (options.stripNode) {
        result = result[0].substring(0, result[0].lastIndexOf('/'))
    } else {
        result = result[0]
    }

    if (result==='')
        result = '.'
    return result
}
