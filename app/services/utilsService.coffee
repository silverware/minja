_ = require 'underscore'

module.exports =

  toggleItemInList: (list, item) ->
    if not list then list = []
    if _.contains list, item
      list = _.without list, item
    else
      list.push item
    list