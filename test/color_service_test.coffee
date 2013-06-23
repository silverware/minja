assert = require "assert"
colorService = require "../app/services/colorService"

list = []

describe 'Color Service', ->
  describe 'opaque', ->
    it 'make color opaque', ->
      assert.equal "rgba(211,223,231,1)", colorService.opaque "rgba(211,223,231,0.4)"
