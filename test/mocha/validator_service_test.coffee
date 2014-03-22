assert = require "assert"
validators = require "../../app/services/validatorService"

isTrue = (names) ->
  for name in names
  	assert.ok validators.isPublicName name

isFalse = (names) ->
  for name in names
  	assert.equal false, validators.isPublicName name

describe 'Validators', ->
  describe 'isPublicName', ->
    it 'should return true, if public name contains a-z or 0-9 and is bigger than 5', ->
      isTrue [
      	"srjdkls"
      	"ajr83"
      	"arc.richter"
      	"Allemania"
      ]
    it 'should return false', ->
      isFalse [
      	"srj"
      	"ajr8"
      	"arc.ric-asdA"
      	""
      	"...."
      ]
