App.Player = Em.Object.extend
  name: ""
  isDummy: false
  isPlayer: true
  isPrivate: false
  attributes: {}

  init: ->
    @_super()
    if not @id
      @set 'id', UniqueId.create()
    @attributes = Em.Object.create()

  editable: (->
    @get("isPlayer") and App.editable
  ).property("isPlayer")

  # used in Members Table
  isPartaking: (->
    _.contains App.Tournament.getPlayers(), @
  ).property()

  # real, if its no dummy player or placeholder
  isRealPlayer: (->
    return (@get('isPlayer') and not @get('isPrivate'))
  ).property('isDummy', 'isPlayer', 'isPrivate')
  
App.Player.reopenClass
  createPlayer: (args) ->
    player = App.Player.create args
    player.set 'attributes', Em.Object.create args.attributes
    player

App.Dummy = App.Player.extend
  isDummy: true
  isPlayer: false
