App.RoundItem = Em.Object.extend
  name: ""
  _round: null
  players: []
  games: []
  dummies: []

  init: ->
    @_super()
    @set "players", Em.ArrayController.create
      content: []
    @set "games", Em.ArrayController.create
      content: []
    @set "dummies", []

  remove: ->
    @_round.removeItem @

  replace: (from, to) ->
    App.Tournament.replacePlayer from, to, @get("_round")

  matchDays: (->
    matchDays = []
    playerCount = @players.get("length")
    gamesPerMatchDay = Math.floor(playerCount/2)
    
    _.chain(@get("games").content)
    .groupBy((item, index) -> Math.floor(index/gamesPerMatchDay))
    .map((chunk, index) -> 
      games = []
      for game in chunk
        games.pushObject game
      matchDays.pushObject
        matchDay: parseInt(index) + 1
        games: games
    )
    matchDays
  ).property("roundItem.games.@each")

  matchDayCount: (->
    @get("matchDays.length")
  ).property("matchDays.@each")


