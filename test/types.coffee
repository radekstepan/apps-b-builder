#!/usr/bin/env coffee
proxy       = do require('proxyquire').noCallThru
assert      = require 'assert'
{ resolve } = require 'path'
fs          = require 'fs'
{ _ }       = require 'lodash'

# Define all them tests here.
tests =
    'coffeescript': 'js'
    'litcoffee': 'js'

# Proxy these.
_fs =
    'exists': (loc, cb) ->
        cb yes
    'stat': (loc, cb) ->
        cb null, { 'isDirectory': -> yes }
    'writeFile': (path, src, cb) ->
        cb null
    'readdir': fs.readdir
    'readFile': fs.readFile

# The builder under test.
build = proxy resolve(__dirname, '../build.coffee'),
    'fs': _fs

# The actual runner of one test.
runner = (lang, type, done) ->
    actual = null

    # Save the JS output.
    _fs.writeFile = (path, output, cb) ->
        actual = output if path.match new RegExp 'build.' + type
        cb null
    
    fixture = 'test/fixtures/' + lang

    build [ fixture, 'test' ], (err) ->
        assert.ifError err
        fs.readFile fixture + '/expected.' + type, 'utf-8', (err, expected) ->
            assert.ifError err
            assert.equal actual, expected
            do done

# Export them tests.
( exports[k] = _.partialRight runner, k, v for k, v of tests )