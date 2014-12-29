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
    @set 'attributes', Em.Object.create()

  editable: (->
    @get("isPlayer") and App.editable
  ).property("isPlayer", 'App.editable')

  # used in Members Table
  # TODO: getPlayers to computed property
  isPartaking: (->
    _.contains App.tournament.bracket.getPlayers(), @
  ).property('App.tournament.bracket.@each.games')

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
