fs = require 'fs'
ndjson = require 'ndjson'



fs.unlinkSync './unique.ndjson'

file = fs.createReadStream './db.ndjson'
entries = ndjson.parse()
file.pipe entries

users = {}
entries.on 'data', (entry) ->
	users[entry.user] ?= {}
	Object.assign users[entry.user], entry

entries.on 'end', ->
	file = fs.createWriteStream './unique.ndjson'
	entries = ndjson.stringify()
	entries.pipe file
	for user, data of users
		entries.write data
	entries.end()
