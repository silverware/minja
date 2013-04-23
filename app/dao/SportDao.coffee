fs = require 'fs'

class SportDao

  load: (fileName) ->
    cs = fs.readFileSync "/#{req.params[0]}.coffee", "utf8"
    js = coffee.compile cs

  find: (key) ->
    @load key

  findAll: ->
    files = fs.readdirSync "/model/sports"
    files.map (file) -> file

module.exports = new SportDao()