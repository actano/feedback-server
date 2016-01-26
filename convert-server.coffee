express = require 'express'
fs = require 'fs'
ndjson = require 'ndjson'
csv = require 'csv-write-stream'



columns = ['user', 'teams', 'teamwork', 'links', 'gantt', 'multiaction']

app = express()
app.get "/unique-counters", (req, res) ->
	users = {}
	db = fs.createReadStream './db.ndjson'
		.pipe ndjson.parse()
	db.on 'data', (entry) ->
		users[entry.user] ?= {}
		Object.assign users[entry.user], entry
	db.on 'end', ->
		generator = csv {headers: columns}
		generator.pipe res
		for user, data of users
			generator.write data
		generator.end()

app.listen 8080, -> console.log 'listening on port 8080'
