App.PlayerPool = Em.Object.create

  players: []
  attributes: []

  init: ->
    @set 'players', []
    @set 'attributes', []

  initPlayers: (members) ->
    members.forEach (member) =>
      @players.pushObject App.Player.create member

  initAttributes: (attributes) ->
    attributes.forEach (attribute) =>
      @attributes.pushObject App.PlayerAttribute.create attribute

  getNewPlayer: ->
    

  createPlayer: (data) ->
    if not data?.name
      data.name = 'Player'
    player = App.Player.create data
    @players.pushObject player
    player

