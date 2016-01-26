express = require 'express'
bodyParser = require 'body-parser'
cors = require 'cors'
fs = require 'fs'
ndjson = require 'ndjson'
auth = require 'basic-auth'


app = express()
app.use bodyParser.json()

file = fs.createWriteStream './db.ndjson'
db = ndjson.stringify()
db.pipe file

app.use '/counters', cors()
app.post '/counters', (req, res) ->
	if req.body.user? then db.write req.body
	res.send 'OK'

app.get "/feedbacks", (req, res) ->
    objUser = auth req
    if objUser and objUser.name is "actano" and objUser.pass is "actano"
        res.sendFile './unique.csv', root: __dirname
    else
        res.set "WWW-Authenticate", "Basic realm=Authorization Required"
        res.status(401).end()

app.listen 80, -> console.log 'listening on port 80'
