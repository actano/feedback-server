express = require 'express'
bodyParser = require 'body-parser'
fs = require 'fs'
ndjson = require 'ndjson'
_ = require 'lodash'

app = express()
app.use bodyParser.json()

file = fs.createWriteStream './db.ndjson'
db = ndjson.stringify()
db.pipe file

whitelistedKeys = ['a', 'b', 'c', 'user']

app.post '/counters', (req, res) ->
	feedback = _.pick req.body, whitelistedKeys
	if feedback.user? then db.write feedback
	res.send 'OK'
    
app.listen 80, -> console.log 'listening on port 80'
