fs = require 'fs'
validators = require '../services/validatorService'
_ = require 'underscore'

class TournamentDao extends require('./daoBase')

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
        allIdentifiers:
          map: 'function(doc) {if(doc.publicName) {emit(null, doc.publicName);} else {emit(null, doc._id)}}'

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
      if err
        callback []
      else
        for t in tournaments
          tournament = t.value
          if tournament.publicName
            tournament.identifier = tournament.publicName
          else
            tournament.identifier = tournament._id
        callback tournaments

  findTournamentsByIds: (ids, callback) ->
    @db.view "tournament/byIds", keys: ids, descending: true, (err, tournaments) ->
      if err then callback [] else callback tournaments

  # Identifier is either the id or the publicName
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
    if "robots.txt" is name
      return callback false
    @db.view "tournament/byPublicName", key: name, descending: true, (err, tournaments) ->
      if err then callback false else callback tournaments.length is 0

  findAllTournamentIdentifiers: (callback) ->
    @db.view "tournament/allIdentifiers", descending: true, (err, tournaments) ->
      if err then callback [] else callback tournaments

module.exports = new TournamentDao()
