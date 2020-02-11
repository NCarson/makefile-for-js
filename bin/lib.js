const program = require('commander')
const fs = require('fs')
const findNodeModules = require('find-node-modules')

const SEP = '/'

exports.writeOptions = function writeOptions(name, newOpts, file=process.stdout) {
    file.write(`#######################################\n`)
    file.write(`# ${name} OPTIONS \n`)
    file.write(`#######################################\n\n`)
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

exports.nodePaths = function nodePath(argFiles) {
    const depends = new Set()
    argFiles.forEach( f => {
        const idx = f.indexOf('node_modules' + SEP)
        if (idx >= 0) { // if we have a npm type path
            f = f.substring(idx + 13, f.length)
            if (f.indexOf(SEP) < 0) { // if no direcs
                depends.add(f)
            } else { // else more direcs
                let direc = []
                f.split(SEP).some( piece => {
                    direc.push(piece)
                    if (piece.indexOf('@') != 0) // if its scoped keep going
                        return true
                })
                depends.add(direc.join(SEP))
            }
        }
    })
    return depends
}
