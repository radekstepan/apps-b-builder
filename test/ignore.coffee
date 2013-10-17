#!/usr/bin/env coffee
proxy       = do require('proxyquire').noCallThru
assert      = require 'assert'
{ resolve } = require 'path'
fs          = require 'fs'
async       = require 'async'
_           = require 'lodash'

# Proxy these.
_fs =
    'exists': (loc, cb) ->
        cb yes
    'stat': (loc, cb) ->
        cb null, { 'isDirectory': -> yes }
    'readdir': fs.readdir
    'readFile': fs.readFile
    'writeFile': fs.writeFile
    'truncate': fs.truncate

# The builder under test.
build = proxy resolve(__dirname, '../build.coffee'),
    'fs': _fs

module.exports =
    'ignore: build files': (done) ->
        fixture = 'test/fixtures/ignore/'
        
        # Read the builds live; no cache.
        get = (cb) ->
            async.map [ "#{fixture}/build.js", "#{fixture}/build.css" ], (path, cb) ->
                fs.readFile path, 'utf-8', cb
            , cb

        # Expected.
        get (err, expected) ->
            assert.ifError err
            
            # Run the build (will clear the builds).
            build [ fixture, fixture ], (err) ->
                assert.ifError err

                # Check again.
                get (err, actual) ->
                    assert.ifError err

                    _.each expected, (item, i) ->
                        assert.equal item, actual[i]

                    do done