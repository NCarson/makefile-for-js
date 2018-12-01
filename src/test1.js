import figlet from 'figlet'
import react from 'react'

figlet('Makefile-for-JS Works!', function(err, data) {
    if (err) {
        console.log('Something went wrong...');
        console.dir(err);
        return;
    }
    console.log(data)
});
