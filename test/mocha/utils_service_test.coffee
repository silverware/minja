assert = require "assert"
utils = require "../../app/services/utilsService"

list = []

describe 'Utils', ->
  describe 'toggleItemInList', ->
    beforeEach ->
      list = ["a", "b", "c"]
    it 'should add an item to the list', ->
      newList = utils.toggleItemInList list, "d"
      assert.deepEqual newList, ["a", "b", "c", "d"]

    it 'should remove an item from the list', ->
      newList = utils.toggleItemInList list, "a"
      assert.deepEqual newList, ["b", "c"]

    it 'should add an item to the list with null list', ->
      newList = utils.toggleItemInList undefined, "d"
      assert.deepEqual newList, ["d"]

      newList = utils.toggleItemInList null, "d"
      assert.deepEqual newList, ["d"]
