assert = require "assert"
colorService = require "../app/services/colorService"

list = []

describe 'Color Service', ->
  describe 'opaque', ->
    it 'make color opaque', ->
      assert.equal "rgba(211,223,231,1)", colorService.opaque "rgba(211,223,231,0.4)"
      assert.equal "rgba(211,2,2,1)", colorService.opaque "rgba(211,2,2,1)"

  describe 'isDefaultColor', ->
    it 'isTrue', ->
      assert.ok colorService.isDefaultColor colorService.defaultColors

    it 'isFalse', ->
      color = colorService.defaultColors
      color.content = "rgba(1,1,1,1)"
      assert.equal false, colorService.isDefaultColor color
