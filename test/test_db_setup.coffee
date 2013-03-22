cradle = require 'cradle'
config = require '../app/server-config'


module.exports =
  setup: (dao, dbName, callback) ->
      connection = new (cradle.Connection)(config.DB_HOST, config.DB_PORT, {auth: {username: config.DB_USER, password: config.DB_PASSWORD}, cache: false})
      dao.db = connection.database dbName
      dao.db.create ->
        dao.initialize()
        callback()

  tearDown: (dao) -> (done) ->
    dao.db.destroy ->
      done()