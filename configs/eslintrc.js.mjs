module.exports = {
    "settings": {
        "react": {
            "version": "detect"
        }
    },
    "env": {
        "browser": true,
        "es6": true,
        "node": true
    },
    "extends": [
        "eslint:recommended",
        "plugin:react/recommended",
        "plugin:import/errors"
    ],
    "parserOptions": {
        "ecmaFeatures": {
            "jsx": true
        },
        "ecmaVersion": 2018,
        "sourceType": "module"
    },
    "plugins": [
        "react"
    ],
    "rules": {
        //mine
        "react/prop-types": "warn",
        "react/no-find-dom-node" : "off",

        "import/no-unresolved": "warn",
        "no-unused-vars": "warn",
        "no-unsafe-finally": "off",
        "no-console": "off",
        "multiline-ternary": "off",
        "no-implicit-coercion": "off",
        "object-property-newline": "off",
        "no-unneeded-ternary": "off",
        "no-floating-decimal": "off",
        "max-lines-per-function": "off",
        "no-mixed-spaces-and-tabs": "off"
        //endmine
    }
};
