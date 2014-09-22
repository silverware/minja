App.PlayerPool = Em.Object.create

  players: []
  attributes: []

  init: ->
    @set 'players', []
    @set 'attributes', []

  initPlayers: (members) ->
    members?.members?.forEach (member) =>
      @players.pushObject App.Player.create member
    members?.membersAttributes?.forEach (attribute) =>
      @attributes.pushObject App.PlayerAttribute.create attribute

  getNewPlayer: (data) ->
   unusedPlayers = _.difference @players, App.Tournament.getPlayers()
   if unusedPlayers.length > 0
     return unusedPlayers[0]
   @createPlayer data

  getPlayerById: (id) ->
    if not id then throw 'Id must be set'
    for player in @players when player.id is id
      return player
      

  createPlayer: (data) ->
    if not data
      data = {}
    if not data.name
      data.name = 'Player'
    player = App.Player.create data
    @players.pushObject player
    player
  
  createAttribute: (data) ->
    attribute = App.PlayerAttribute.create data
    @attributes.pushObject attribute
    attribute

  remove: (player) ->
    if App.Tournament.getPlayers().contains player
      return
    if player.isInitialPlayer
      return
    @players.removeObject player

  removeAttribute: (attribute) ->
    @attributes.removeObject attribute

