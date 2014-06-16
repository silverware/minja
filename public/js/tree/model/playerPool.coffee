App.PlayerPool =

  players: []

  initPlayers: (members) ->
    members.forEach (member) =>
      @players.pushObject App.Player.create member

  getNewPlayer: ->
    

  createPlayer: (data) ->
    if not data?.name
      data.name = 'Player'
    player = App.Player.create data
    @players.pushObject player
    player

