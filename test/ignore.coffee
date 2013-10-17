#!/usr/bin/env coffee
proxy       = do require('proxyquire').noCallThru
assert      = require 'assert'
{ resolve } = require 'path'
fs          = require 'fs'
async       = require 'async'

# Proxy these.
_fs =
    'exists': (loc, cb) ->
        cb yes
    'stat': (loc, cb) ->
        cb null, { 'isDirectory': -> yes }
    'readdir': fs.readdir
    'readFile': fs.readFile

# The builder under test.
build = proxy resolve(__dirname, '../build.coffee'),
    'fs': _fs

module.exports =
    'ignore: build files': (done) ->

        fixture = 'test/fixtures/ignore/'

        async.map [ "#{fixture}/build.js", "#{fixture}/build.css" ], (path, cb) ->
            fs.readFile path, 'utf-8', cb
        , (err, results) ->
            assert.ifError err
            
            # Test against these.
            [ js, css ] = results

            expected = { js, css }

            # Check against this.
            i = 0
            _fs.writeFile = (path, a, cb) ->
                i++
                # The same?
                assert.equal a, expected[path.split('.').pop()]
                # Exit?
                do done if i is 2

            # Run the build.
            build [ fixture, fixture ], (err) ->
                assert.ifError err