#!/usr/bin/env coffee
eco = require 'eco'

module.exports = [
    'scripts'
    '.eco'
    (src, cb) ->
        try
            cb null, "module.exports = #{eco.precompile(src)}"
        catch err
            cb err
]