assert = require "assert"
dao =require "../../app/daos/userDao"
User = require "../../app/models/user"
testDb = require './test_db_setup'

createUser = (initialData) ->
  new User initialData


ribery = createUser email: "ribery@fcb.de"
hans = createUser email: "hans@fcb.de", password: "password"
lahm = createUser email: "lahm@fcb.de"

describe 'UserDao', ->

  beforeEach (done) ->
    testDb.setup dao, "user_test", ->
      dao.save ribery, -> done()
  afterEach testDb.tearDown dao

  describe '#create user with email and password', ->
    it 'should save a user with hashed password', (done) ->
      dao.create hans.email, hans.password, (user) ->
        dao.find user._id, (saved) ->
          assert.equal saved.email, hans.email
          assert.equal saved.password, dao.hashPassword hans.password
          done()

    it 'should save a facebook user without password', (done) ->
      dao.create lahm.email, null, (user) ->
        dao.find user._id, (saved) ->
          assert.equal saved.email, lahm.email
          assert.equal saved.password, null
          done()


  describe '#create user after facebook-login', ->
    it 'should save a user', (done) ->
      dao.findOrCreateByEmail "test@example.com", (err, user) ->
        assert.equal null, err
        assert.notEqual null, user
        dao.find user._id, (user) ->
          assert.equal user.email, "test@example.com"
          done()

  describe '#create user after facebook-login, when user exists', ->
    it 'should find an existing user', (done) ->
      dao.findByEmail "ribery@fcb.de", (user, err) ->
        assert.equal null, err
        assert.equal user.email, ribery.email
        done()

    it 'should find an existing user', (done) ->
      dao.findOrCreateByEmail "ribery@fcb.de", (err, user) ->
        assert.equal null, err
        assert.equal user.email, ribery.email
        done()

  describe '#validPassword', ->
    it 'should return true', (done) ->
      paule = createUser password: dao.hashPassword "password"
      assert.ok dao.validPassword paule, "password"
      done()

  #describe '#addFavorite', ->
  #  it 'should save the user with new favorite tournament', (done) ->

