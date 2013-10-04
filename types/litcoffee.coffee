#!/usr/bin/env coffee
cs = require 'coffee-script'

module.exports = [
    'scripts'
    '.litcoffee'
    (src, cb) ->
        try
            cb null, cs.compile src, { 'bare': 'on', 'literate': yes }
        catch err
            cb err
]