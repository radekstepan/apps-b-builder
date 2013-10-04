#!/usr/bin/env coffee
Builder = require 'component-builder'

{ _ }    = require 'lodash'
async    = require 'async'
{ exec } = require 'child_process'
path     = require 'path'
fs       = _.extend {}, require('fs'), require('fs-extra')
log      = require 'node-logging'

module.exports = (io, cb) ->
    # Resolve paths.
    return cb 'Incorrect number of params' if io.length isnt 2
    io = _.map io, (rel) -> path.resolve process.cwd(), rel

    # Check the dirs exist.
    async.each io, (loc, cb) ->
        fs.exists loc, (ya) ->
            return cb "#{loc} does not exist" unless ya
            fs.stat loc, (err, stats) ->
                return cb err if err
                return cb "#{loc} is not a directory" unless stats.isDirectory()
                cb null
    , (err) ->
        return cb err if err

        # Build our handlers based on types.
        dir = __dirname
        fs.readdir dir + '/types', (err, files) ->
            return cb err if err

            [ input, output ] = io

            # Load them handlers from our /types.
            handlers = {}
            _.each files, (file) ->
                [ hook, extensions, handler ] = exported = require dir + '/types/' + file
                handlers[hook] ?= {}

                switch
                    # An Array.
                    when _.isArray(extensions)
                        ( handlers[hook][ext] = wrapper.apply(@, exported) for ext in extensions )
                    
                    # A String.
                    when _.isString(extensions)
                        handlers[hook][extensions] = wrapper.apply @, exported

            # Init a new builder.
            builder = new Builder input

            # Use our custom hooks.
            builder.use hooker handlers

            # Read the `component.json` file.
            async.waterfall [ (cb) ->
                fs.readJson input + '/component.json', cb

            # Install deps?
            (json, cb) ->
                # Why you need deps? Go native... :)
                return cb(null) unless json.dependencies

                # Run them installs in series.
                async.eachSeries ( "#{n}@#{v}" for n, v of json.dependencies ), (dep, cb) ->
                    exec "#{dir}/node_modules/.bin/component-install #{dep} --out #{input}/components", (err, stdout, stderr) ->
                        return cb err if err
                        return cb stderr if stderr
                        cb null
                , cb

            # Build it...
            , (cb) ->
                # TODO: deal with assets.
                builder.build (err, res) ->
                    cb err, res

            # ... and they will come!
            , (res, cb) ->
                write = (where, what, cb) ->
                    return fs.writeFile "#{output}/build.#{where}", what, cb
                    # TODO: switch on minify again (or lint individual JS resources?).
                    minify[where] what, (err, out) ->
                        return cb err if err
                        fs.writeFile "#{output}/build.#{where}", out, cb

                async.parallel [
                    _.partial write, 'js', res.require + res.js
                    _.partial write, 'css', res.css
                ], cb

            # Done.
            ], cb

# What are the targets we are coverting to?
convertTo =
    scripts: '.js'
    styles: '.css'

# Load a file, handle it, switch it, go home.
wrapper = (hook, extension, handler) ->
    (pkg, file, cb) ->
        p = pkg.path file
        # Read file.
        fs.readFile p, 'utf8', (err, src) ->
            return cb err if err
            # Process in handler.
            handler src, (err, out) ->
                if err
                    log.bad file
                    return cb err.message
                
                # Switcheroo.
                name = path.basename(file, extension) + convertTo[hook]
                dir = '' if (dir = path.dirname(file) + '/') is './'
                pkg.addFile hook, dir + name, out
                pkg.removeFile hook, file
                # We done.
                cb null

# Register all hooks.
hooker = (handlers) ->
    (builder) ->
        for hook, obj of handlers then do (hook, obj) ->
            builder.hook "before #{hook}", (pkg, cb) ->
                # Empty?
                return cb(null) unless (files = pkg.config[hook] or []).length
                
                # Map to handlers.
                files = _.map files, (file) ->
                    (cb) ->
                        cb = _.wrap cb, (fn, err) ->
                            fn err

                        return fn(pkg, file, cb) if fn = obj[path.extname(file)]
                        cb null
                
                # And exec in series (why!?).
                async.series files, (err) ->
                    cb err

# Minifiers.
minify  =
    js: (src, cb) ->
        try
            clean = (require('uglify-js').minify(src, 'fromString': yes)).code
        catch err
            return cb err
        cb null, clean
    
    css: (src, cb) ->
        try
            clean = require('clean-css').process src
        catch err
            return cb err
        cb null, clean