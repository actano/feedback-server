fs = require 'fs'
ndjson = require 'ndjson'
csv = require 'csv-write-stream'



fs.unlinkSync './unique.csv'

columns = ['user', 'teams', 'teamwork', 'links', 'gantt', 'multiaction']
fs.createReadStream './unique.ndjson'
	.pipe ndjson.parse()
	.pipe csv {headers: columns}
	.pipe fs.createWriteStream './unique.csv'
