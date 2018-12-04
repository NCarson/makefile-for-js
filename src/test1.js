import emoji from 'node-emoji'

function klassy(text) {
    return emoji.emojify(`:tada: ${text} :tophat: :cat:`, (name)=> console.log("cant find emoji",name))
}
export default klassy
