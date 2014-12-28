App.Bracket = Em.ArrayController.extend
  winPoints: 3
  drawPoints: 1
  qualifierModus: "aggregate"
  timePerGame: 20
  gamesParallel: 1
  settings: {}
  gameAttributes: []
  content: []

  init: ->
    @_super()
    @set 'gameAttributes', []

  hasRounds: (->
    return @get('length') isnt 0
  ).property('@each')

  games: (->
    @reduce (tournamentGames, round) ->
      tournamentGames = tournamentGames.concat round.get("games")
    , []
  ).property('@each.games')

  getGamesByPlayer: (player) ->
    @reduce (games, round) ->
      roundGames = round.get("games").filter (game) ->
        game.get("players").contains player
      if roundGames.length > 0
        games = games.concat round: round, games: roundGames
      games
    , []

  getPlayers: ->
    _.chain(@map (round) -> round.getPlayers()).flatten().uniq().value()

  addGroupRound: ->
    if @addRound()
      $("#settings .close").click()
      @pushObject App.GroupRound.create
        name: App.i18n.bracket.groupStage
        _previousRound: @lastRound()

  addKoRound: ->
    if @addRound()
      $("#settings .close").click()
      @pushObject App.KoRound.create
        name: App.i18n.bracket.koRound
        _previousRound: @lastRound()

  addRound: ->
    if @get('content.length') is 0 or @lastRound().validate()
      @lastRound()?.set "editable", false
      return true
    else
      App.Popup.showInfo
        title: ""
        bodyContent: App.i18n.bracket.lastRoundNotValid
      return false

  lastRound: ->
    _.last @get('content')

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
