App.PlayerPool =

  players: []

  getNewPlayer: ->
    

  createPlayer: (data) ->
    if not data?.name
      data.name = 'Player'
    player = App.Player.create data
    @players.pushObject player
    player

