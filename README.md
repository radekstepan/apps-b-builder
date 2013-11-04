#apps-b-builder

A [component.io](https://github.com/component/component) based builder for making modular JS components.

[ ![Codeship Status for intermine/apps-b-builder](https://www.codeship.io/projects/5416ca40-118b-0131-48c9-420f81acb815/status?branch=master)](https://www.codeship.io/projects/7802)

##Quick Start

Globally install the npm package:

```bash
$ sudo npm install apps-b-builder -g
```

Then specify the input and output path to build a component:

```bash
# relative to current working directory
$ apps-b ./src/ ./build/
```

##Create a component

A component consists of one `component.json` config file and one or more [source file](#supported-types). Script source files use the [CommonJS](http://wiki.commonjs.org/wiki/Modules/1.1) Modules/1.1 implementation so you use `require` and `module.exports` to link between modules & components. This is a standard in the Node.js community.

###Component config file

To write a component config file in JSON refer to the [standard](https://github.com/component/component/wiki/Spec).

```javascript
{
    "name": "app",
    // Which file do we require as the main file.
    "main": "app.js",
    "version": "1.0.0",
    // Other components.
    "dependencies": {
        "visionmedia/superagent": "*",
        "necolas/normalize.css": "*",
        "component/marked": "*"
    },
    "scripts": [
        "app.coffee",
        "template.eco"        
    ],
    "styles": [
        "styles/fonts.css",
        "styles/app.styl"
    ]
}
```

###Supported types

Have a look into the `test/fixtures` directory for examples of supported filetypes:

1. [CoffeeScript](http://coffeescript.org/); compile-to-JS language, goes into the `scripts` section
1. CSS, goes into the `styles` section
1. [Eco](https://github.com/sstephenson/eco); a templating language, goes into the `scripts` section
1. JavaScript, goes into the `scripts` section
1. [Literate CoffeeScript](http://coffeescript.org/#literate); mix [Markdown](http://daringfireball.net/projects/markdown/) and CS syntax, goes into the `scripts` section
1. [Stylus](http://learnboost.github.io/stylus/); a CSS preprocessor including [nib](http://visionmedia.github.io/nib/) CSS3 extensions, goes into the `styles` section

###JavaScript API

You can programatically build files too:

```coffeescript
build = require './build.coffee'

build [ './src/', './build/' ], (err) ->
    throw err if err
```

##Test it

Tests using Mocha:

```bash
$ npm install -d
$ make test
```