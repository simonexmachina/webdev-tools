#!/usr/local/bin/coffee

# Requirements:
# npm install -g glob gm async underscore

path = require 'path'
fs = require 'fs'
glob = require 'glob'
gm = require 'gm'
async = require 'async'
_ = require 'underscore'

dir = path.resolve "#{__dirname}/..", process.argv[2]
glob "#{dir}/**", (err, files)->
	tasks = []
	if err then console.log err
	else for file in files
		do (file)->
			if fs.statSync(file).isDirectory()
				return tasks.push (cb)->
					cb.call null, null, file: file, value: {}
			tasks.push (cb)->
				gm(file).size (err, value)->
					if err then console.log err
					else
						value.file = file
					cb.call(null, err, value)
	async.series tasks, (err, results)->
		if err then console.log err
		else for value in _.sortBy results, 'file'
			console.log "#{path.basename value.file}: #{value.width}x#{value.height}"
