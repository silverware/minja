cradle = require 'cradle'
config = require '../server-config'

class DaoBase 
  
  constructor: (@dbName) ->
    connection = new (cradle.Connection)(config.DB_HOST, config.DB_PORT, {auth: {username: config.DB_USER, password: config.DB_PASSWORD}, cache: false})
    @db = connection.database @dbName
    @db.exists (err, exists) =>
      if not exists
        @db.create =>
          @initialize()
          for data in @testdata()
            @db.save data, ->
      else
        @initialize()

  initialize: ->
    # Extension-Point: initialize Views

  testdata: -> []

  find: (id, callback) ->
    @db.get id, (error, result) ->
      if error then callback null, error else callback result

  save: (item, callback) ->
    item.created_at = new Date()
    @db.save item, (error, result) ->
      if error then callback null, error else callback result

  merge: (id, object, callback) ->
    @db.merge id, object, (error, result) ->
      if error then callback null, error else callback result

  remove: (id, rev, callback) ->
    @db.remove id, rev, (error, result) ->
      if error then callback null, error else callback result

  removeAttachments: (doc, ids, readyCallback) ->
    if ids.length <= 0
      return readyCallback doc
    id = ids.pop()
    @db.removeAttachment doc, id, (err, result) =>
      @removeAttachments result, ids, readyCallback

  saveAttachments: (attachments, doc, readyCallback) ->
      if attachments.length <= 0
        return readyCallback()
      attachment = attachments.pop()
      @db.saveAttachment doc, attachment, (err, data) =>
        @saveAttachments attachments, data, readyCallback

module.exports = DaoBase