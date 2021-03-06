assert = require "assert"
User = require "../../app/models/user"

ribery = User.create email: "ribery@fcb.de"

describe '#validation of model', ->
  it 'should validate an user true', (done) ->
    assert.ok User.validate ribery
    done()

  it 'should validate and return errors', (done) ->
    ribery.email = {huhu: "falsch"}
    assert.equal false, User.validate(ribery)
    done()

  it 'should validate true', (done) ->
    user =
      email: "huhu"
      password: "password"
    assert.ok User.validate(user)
    user =
      email: 'email'
      notDefinedProperty: 22
    assert.ok User.validate(user)
    done()

  it 'should validate false due to missing required field', (done) ->
    user =
      password: 'password'
    assert.equal false, User.validate(user)
    done()

  it 'should validate false due to blank string', (done) ->
    user =
      email: ''
    assert.equal false, User.validate(user)
    done()

