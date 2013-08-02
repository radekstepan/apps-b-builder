#!/usr/bin/env coffee
cs = require 'coffee-script'

module.exports = [
    'scripts'
    '.coffee'
    (src, cb) ->
        try
            cb null, cs.compile src, 'bare': 'on'
        catch err
            cb err
]