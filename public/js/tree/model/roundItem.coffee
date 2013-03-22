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


