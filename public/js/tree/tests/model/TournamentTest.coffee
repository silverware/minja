buster.testCase "Tournament Model"
  setUp: ->
    @tournament = App.Tournament
    @tournament.clear()

  "Ersetze Spieler-Objekte nach Eintragen von Ergebnissen": ->
    @tournament.addKoRound()
    round1 = @tournament.objectAt 0
    round1game1 = round1.addItem()
    round1game2 = round1.addItem()

    @tournament.addKoRound()
    round2 = @tournament.objectAt 1
    round2game = round2.addItem()

    assert.equals round2game.get("player1"), round1game1.get("winnerDummy")

    @tournament.replacePlayer(round1game1.get("winnerDummy"), round1game1.get("player1"), round1)
    
    assert.equals round2game.get("player1"), round1game1.get("player1")


  "Die Spiele aller Turnierrunden holen": ->
    round1 = @tournament.addGroupRound()
    # 4er Gruppe -> 6 Spiele
    round1.addItem()

    round2 = @tournament.addKoRound()
    ## zwei Spiele
    round2.addItem()
    round2.addItem()

    games = @tournament.get("games")

    assert.equals 8, games.length


###
  "öffnet bei Edit das Popup": ->
    App.TournamentPopup.show = @stub()

    @tournament.edit()

    assert.calledOnce App.TournamentPopup.show
###