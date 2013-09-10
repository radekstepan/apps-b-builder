#!/usr/bin/env coffee
stylus = require 'stylus'
nib    = require 'nib'

module.exports = [
    'styles'
    '.styl'
    (src, cb) ->
        stylus(src).use(nib()).render cb
]