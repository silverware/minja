App.Tournament.Participants = Em.Object.extend
  players: []
  attributes: []

  init: ->
    @set 'players', []
    @set 'attributes', []

  initPlayers: (members) ->
    members?.members?.forEach (member) =>
      @players.pushObject App.Player.createPlayer member
    members?.membersAttributes?.forEach (attribute) =>
      @attributes.pushObject App.PlayerAttribute.create attribute

  sortedPlayers: (->
    @get("players").sort (player1, player2) ->
      if player1.get('isPartaking') is player2.get('isPartaking')
        return player1.get('name').toLowerCase() > player2.get('name').toLowerCase()
      return player2.get('isPartaking')
  ).property("players.@each.name", "players.@each.isPartaking")

  # takes a player thats not present in the bracket
  # otherwise creates a new player
  getNewPlayer: (data) ->
   unusedPlayers = _.difference @players, App.Tournament.Bracket.getPlayers()
   if unusedPlayers.length > 0
     return unusedPlayers[0]
   data._isTemporary = true
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
    player = App.Player.createPlayer data
    @players.pushObject player
    player
  
  createAttribute: (data) ->
    attribute = App.PlayerAttribute.create data
    @attributes.pushObject attribute
    attribute

  filterOutTemporaryPlayers: ->
    playersInBracket = App.Tournament.getPlayers()
    @get('players').filter (player) ->
      return not player._isTemporary or playersInBracket.contains player

  remove: (player) ->
    if App.Tournament.getPlayers().contains player
      return
    if player.isInitialPlayer
      return
    @players.removeObject player

  removeAttribute: (attribute) ->
    @attributes.removeObject attribute

  clear: ->
    @players.clear()
    @attributes.clear()

App.Tournament.Participants = App.Tournament.Participants.create()
