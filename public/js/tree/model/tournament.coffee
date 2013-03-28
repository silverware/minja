App.Tournament = Em.ArrayController.create
  winPoints: 3
  drawPoints: 1
  gameAttributes: []
  content: []

  games: (->
    @reduce (tournamentGames, round) -> 
      tournamentGames = tournamentGames.concat round.get("games")
    , []
  ).property('@each.games')

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
    if @content.length == 0 || @lastRound().validate()
      @lastRound()?.set "editable", false
      return true
    else
      App.Alert.openWarning "Die letzte Runde ist nocht nicht valide. Entweder sind noch nicht alle Qualifikanten der vorletzten Runde übernommen worden, oder die Anzahl der Qualifikanten der letzten Runde ist kleiner als zwei."
      return false

  lastRound: ->
    _.last @content

  removeLastRound: ->
    @removeObject @lastRound()
    @lastRound()?.set "editable", true


  # In alle nachfolgenden Runden werden wird der From-spieler durch den To-Spieler ersetzt
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
