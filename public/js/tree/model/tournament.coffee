App.Tournament = Em.ArrayController.extend
  winPoints: 3
  drawPoints: 1
  qualifierModus: "aggregate"
  timePerGame: 20
  gamesParallel: 1
  gameAttributes: []
  content: []

  games: (->
    @reduce (tournamentGames, round) ->
      tournamentGames = tournamentGames.concat round.get("games")
    , []
  ).property('@each.games')

  gamesByPlayer: (player) ->
    @get("games").filter (game) ->
      game.get("players").indexOf player

  addGroupRound: ->
    if @addRound()
      $("#settings .close").click()
      @pushObject App.GroupRound.create
        name: App.i18n.groupStage
        _previousRound: @lastRound()

  addKoRound: ->
    if @addRound()
      $("#settings .close").click()
      @pushObject App.KoRound.create
        name: App.i18n.koRound
        _previousRound: @lastRound()

  addRound: ->
    if @content.length is 0 or @lastRound().validate()
      @lastRound()?.set "editable", false
      return true
    else
      App.Popup.showInfo
        title: ""
        bodyContent: App.i18n.lastRoundNotValid
      return false

  lastRound: ->
    _.last @content

  removeLastRound: ->
    @removeObject @lastRound()
    @lastRound()?.set "editable", true


  # replace a player by another, starting at specified round
  replacePlayer: (from, to, fromRound) ->
    isFurtherRound = false
    if from and to
      @forEach (round) ->
        if isFurtherRound
          round.items.forEach (roundItem) ->
            roundItem.players.forEach (player) ->
              if player is from
                i = roundItem.players.indexOf player
                roundItem.players.removeObject player
                roundItem.players.insertAt i, to
        if round is fromRound
          isFurtherRound = true


App.qualifierModi =
  BEST_OF: Em.Object.create {id: "bestof", label: "Best Of X"}
  AGGREGATE: Em.Object.create {id: "aggregate", label: "Aggregated"}




App.Tournament = App.Tournament.create()
