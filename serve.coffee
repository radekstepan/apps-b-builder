#!/usr/bin/env coffee
path             = require 'path'
buffet           = require 'buffet'
{ createServer } = require 'http'

module.exports = (dir, cb) ->    
    server = createServer()
    buff = buffet root: path.resolve process.cwd(), dir
    
    server.on 'request', (req, res) ->
        buff req, res, ->
            buff.notFound req, res

    server.listen process.env.PORT, ->
        cb null, String(server.address().port)