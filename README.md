#apps-b-builder

A [component.io](https://github.com/component/component) based builder for making modular JS packages.

[ ![Codeship Status for intermine/apps-b-builder](https://www.codeship.io/projects/5416ca40-118b-0131-48c9-420f81acb815/status?branch=master)](https://www.codeship.io/projects/7802)

##Quick Start

```bash
$ sudo npm install apps-b-builder -g
```

Then specify the input and output path to build:

```bash
# relative to current working directory
$ apps-b ./src/ ./build/
```

##Supported types

Have a look into the `test/fixtures` directory for examples of supported filetypes:

1. [CoffeeScript](http://coffeescript.org/); compile-to-JS language
1. CSS
1. [Eco](https://github.com/sstephenson/eco); a templating language
1. JavaScript
1. [Literate CoffeeScript](http://coffeescript.org/#literate); mix [Markdown](http://daringfireball.net/projects/markdown/) and CS syntax
1. [Stylus](http://learnboost.github.io/stylus/); a CSS preprocessor including [nib](http://visionmedia.github.io/nib/) CSS3 extensions

##JavaScript API

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