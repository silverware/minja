cradle = require 'cradle'
config = require '../../app/server-config'


module.exports =
  tearDown: (dao) -> (done) ->
    dao.db.destroy ->
      done()

  connect: (dbName, callback) ->
      connection = new (cradle.Connection)(config.DB_HOST, config.DB_PORT, {auth: {username: config.DB_USER, password: config.DB_PASSWORD}, cache: false})
      callback(connection.database dbName)

