express = require 'express'
bodyParser = require 'body-parser'
fs = require 'fs'
ndjson = require 'ndjson'
_ = require 'lodash'
auth = require 'basic-auth'


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

app.get "/feedbacks", (req, res) ->
    objUser = auth req
    if objUser and objUser.name is "Jimmy" and objUser.pass is "admin"
        res.sendFile './unique.csv', root: __dirname
    else
        res.set "WWW-Authenticate", "Basic realm=Authorization Required"
        res.status(401).end()

app.listen 80, -> console.log 'listening on port 80'
