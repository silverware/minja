assert = require "assert"
dao = require "../../app/daos/chatDao"
Message = require "../../app/models/message"
testDb = require './test_db_setup'

messages = [
  Message.create tournament_id: "paulanercup", authorType: dao.authorTypes.leader
  Message.create tournament_id: "paulanercup", authorType: dao.authorTypes.guest, author: "Peter"
  Message.create tournament_id: "ricolacup", authorType: dao.authorTypes.leader
]

i18n =
  date: -> "date"

assertResultContains = (result, id) ->
  assert.ok not result.every (x) -> x.id is not id

describe 'ChatDao', ->

  beforeEach (done) ->
    testDb.setup dao, "chat_test", ->
      dao.save messages, (re) ->
        for i in [0..re.length - 1]
          messages[i]._id = re[i].id
        done()

  afterEach testDb.tearDown dao

  describe 'findMessagesByTournamentId', ->

    it 'should return all paulanerMessages', (done) ->
      dao.findMessagesByTournamentId "paulanercup", i18n, first: 0, limit: 5, (result) ->
        assert.equal result.length, 2
        assertResultContains result, messages[0]._id
        assertResultContains result, messages[1]._id
        done()

    it 'should return first paulanerMessages', (done) ->
      dao.findMessagesByTournamentId "paulanercup", i18n, first: 0, limit: 1, (result) ->
        assert.equal result.length, 1
        assertResultContains result, messages[0]._id
        done()

    it 'should return second paulanerMessages', (done) ->
      dao.findMessagesByTournamentId "paulanercup", i18n, first: 1, limit: 1, (result) ->
        assert.equal result.length, 1
        assertResultContains result, messages[1]._id
        done()

