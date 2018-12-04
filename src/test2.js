//import npm_klassy from 'makefile-for-js-example'

import klassy from './test1'
import Config from './config'

const main = window.addEventListener('load', function() { 
    const root = document.getElementById("app")
    const el = document.createElement("h3")
    root.appendChild(el)
    el.innerHTML = klassy("OMG! I was build by a Makefile")
    el.className = 'test2 title'

    var dist = window.makefileforjs
    console.log("window.makefileforjs =", dist)

})
export default main
