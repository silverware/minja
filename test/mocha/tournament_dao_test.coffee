assert = require "assert"
dao = require "../../app/daos/tournamentDao"
Tournament = require "../../app/models/tournament"
User = require "../../app/models/user"
testDb = require './test_db_setup'

console.log 'huhuu'
createTournament = (initialData) ->
  Tournament.create initialData

paulanercup = createTournament publicName: "paulanercup", user_id: "thomas"
ricolacup = createTournament publicName: "ricolacup", user_id: "hans"

describe 'TournamentDao', ->

  beforeEach (done) ->
    testDb.setup dao, "tournament_test", ->
      dao.save [ricolacup, paulanercup], (s) ->
        ricolacup._id = s[0].id
        paulanercup._id = s[1].id
        done()

  afterEach testDb.tearDown dao

  describe 'checkPublicName', ->

    it 'should return true', (done) ->
      dao.checkPublicName "Fussballturnier", (available) ->
        assert.equal true, available
        done()

    it 'should return false', (done) ->
      dao.checkPublicName "ricolacup", (available) ->
        assert.equal false, available
        done()

    it 'should return false', (done) ->
      dao.checkPublicName "ric", (available) ->
        assert.equal false, available
        done()

    it 'should return false', (done) ->
      dao.checkPublicName "rico laa", (available) ->
        assert.equal false, available
        done()

  describe '#findTournamentsByUser', ->

    it 'should return 1 tournament', (done) ->
      dao.findTournamentsByUser id: "hans", (results) ->
        assert.equal 1, results.length
        assert.equal "ricolacup", results[0].value.publicName
        done()

    it 'should return no tournament', (done) ->
      dao.findTournamentsByUser id: "niemand", (results) ->
        assert.equal 0, results.length
        done()

  describe '#findTournamentByIdentifier', ->
    it 'should return ricolaup by publicname', (done) ->
      dao.findTournamentByIdentifier ricolacup.publicName, (result) ->
        assert.notEqual null, result
        assert.equal ricolacup._id, result._id
        done()

    it 'should return ricolaup by id', (done) ->
      dao.findTournamentByIdentifier ricolacup._id, (result) ->
        assert.notEqual null, result
        assert.equal ricolacup._id, result._id
        done()

    it 'should return paulanercup by publicname', (done) ->
      dao.findTournamentByIdentifier paulanercup._id, (result) ->
        assert.notEqual null, result
        assert.equal paulanercup._id, result._id
        done()

    it 'should return no tournament', (done) ->
      dao.findTournamentByIdentifier "noid", (result) ->
        assert.equal null, result
        done()

  describe '#findTournamentsByIds', ->
    it 'should return 2 tournaments', (done) ->
      dao.findTournamentsByIds [ricolacup._id, paulanercup._id], (tournaments) ->
        assert.equal 2, tournaments.length
        done()

    it 'should return 1 tournament', (done) ->
      dao.findTournamentsByIds [ricolacup._id], (tournaments) ->
        assert.equal 1, tournaments.length
        done()

    it 'should return 0 tournament', (done) ->
      dao.findTournamentsByIds null, (tournaments) ->
        assert.equal 0, tournaments.length
        done()

    it 'should return 0 tournament by empty list', (done) ->
      dao.findTournamentsByIds [], (tournaments) ->
        assert.equal 0, tournaments.length
        done()

  describe '#findAllTournamentIdentifiers', ->
    it 'should return all tournaments', (done) ->
      dao.findAllTournamentIdentifiers (tournaments) ->
        assert.equal paulanercup.publicName, tournaments[0].value
        assert.equal ricolacup.publicName, tournaments[1].value
        done()
