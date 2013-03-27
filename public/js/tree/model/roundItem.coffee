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
    gamesPerRound = Math.floor(@roundItem.players.get("length") / 2)
    for index in [0..@roundItem.games.get("length") - 1]
      games.pushObject
        game: @get("roundItem.games").objectAt index
        gameIndex: index
        newRound: index != 0 and (index + gamesPerRound) % gamesPerRound == 0
    games
  ).property("roundItem.games.@each")


