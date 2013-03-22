fs = require 'fs'
im = require 'imagemagick'
validators = require '../services/validatorService'
_ = require 'underscore'

class TournamentDao extends require('./DaoBase')

  constructor: ->
    super 'tournaments'

  initialize: ->
    @db.save '_design/tournament',
      views:
        byIds: 
          map: 'function(doc) {emit(doc._id, doc)}'
        byUser:
          map: 'function(doc) {emit(doc.user_id, doc)}'
        byPublicName:
          map: 'function(doc) {emit(doc.publicName, doc)}'
        byIdentifier:
          map: 'function(doc) {emit(doc._id, doc); if(doc.publicName) {emit(doc.publicName, doc);}}'

  mergeImages: (doc, attachments, imageData, files, callback) ->
    imageIds = []
    for id, data of imageData
      imageIds.push "image/#{id}"

    @removeImages doc, attachments, imageIds, (result) =>
      images = []
      for id, data of imageData
        file = files[id]
        if not file?
          continue
        image =
          name: "image/" + id
          contentType: file.type
          body: fs.readFileSync(file.path)
        images.push image
      @saveAttachments images, result, callback

  removeImages: (doc, attachments, imageIds, readyCallback) =>
    removeIds = []
    if attachments?
      for id of attachments
        if not _.contains imageIds, id
          removeIds.push id
    @removeAttachments doc, removeIds, readyCallback

  findTournamentsByUser: (user, callback) ->
    @db.view "tournament/byUser", key: user.id, descending: true, (err, tournaments) ->
      if err then callback [] else callback tournaments

  findTournamentsByIds: (ids, callback) ->
    @db.view "tournament/byIds", keys: ids, descending: true, (err, tournaments) ->
      if err then callback [] else callback tournaments

  # Identifier could be the id or the publicName  
  findTournamentByIdentifier: (id, callback) ->
    @db.view "tournament/byIdentifier", key: id, (err, tournament) ->
      if tournament? and tournament.length == 1
        t = tournament[0].value
        t.id = t._id
        t.rev = t._rev
        callback t
      else
        callback null

  checkPublicName: (name, callback) ->
    if not validators.isPublicName name 
      return callback false
    @db.view "tournament/byPublicName", key: name, descending: true, (err, tournaments) ->
      if err then callback false else callback tournaments.length == 0

module.exports = new TournamentDao()