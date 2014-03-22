assert = require "assert"
dao = require "../../app/daos/tournamentDao"
Tournament = require "../../app/models/tournament"
testDb = require './test_db_setup'

createTournament = (initialData) ->
  new Tournament initialData

paulanercup = createTournament publicName: "paulanercup", user_id: "thomas"
ricolacup = createTournament publicName: "ricolacup", user_id: "hans"

describe 'DaoBase', ->

  beforeEach (done) ->
    testDb.setup dao, "tournament_test", ->
      dao.save [ricolacup, paulanercup], (s) ->
        ricolacup._id = s[0].id
        ricolacup._rev = s[0].rev
        paulanercup._id = s[1].id
        done()

  afterEach testDb.tearDown dao

  describe '#save', ->
    it 'should save without error', (done) ->
      t = createTournament publicName: "testTurnier"
      dao.save t, (tournament) ->
        assert.notEqual null, tournament
        dao.find tournament.id, (result) ->
          assert.equal result.publicName, "testTurnier"
          done()

  describe '#find', ->
    it 'should find a tournament', (done) ->
      dao.find paulanercup._id, (result) ->
        assert.notEqual null, result
        assert.equal paulanercup.publicName, result.publicName
        done()

    it 'should not find a tournament', (done) ->
      dao.find "noId", (result, error) ->
        assert.equal null, result
        assert.notEqual null, error
        assert.ok error.error, "not_found"
        done()

  describe '#merge', ->
    it 'should merge info into a tournament', (done) ->
      data =
        info:
          name: "Name"
          date: "date"
      dao.merge paulanercup._id, data, (result) ->
        assert.notEqual null, result
        assert.ok result.ok
        dao.find paulanercup._id, (result) ->
          assert.deepEqual data.info, result.info
          done()

    it 'should not merge a tournament', (done) ->
      dao.merge "noId", name: "Name", (result, error) ->
        assert.equal null, result
        assert.notEqual null, error
        assert.ok error.error, "not_found"
        done()

  describe '#remove', ->
    it 'should remove without error', (done) ->
      dao.remove ricolacup._id, ricolacup._rev, (result) ->
        assert.notEqual null, result
        assert.ok result.ok
        dao.find ricolacup._id, (result) ->
          assert.equal null, result
          done()

    it 'should not remove with noId', (done) ->
      dao.remove "noId", ricolacup._rev, (result, error) ->
        assert.notEqual null, error
        assert.equal null, result
        assert.ok error.error, "not_found"
        done()
