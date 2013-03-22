buster.testCase "Group Model"
  setUp: ->
    @round = App.GroupRound.create()
    @group = App.Group.create
      _round: @round
    @fillPlayers = (count) =>
      players = []
      for i in [1..count]
        player = App.Player.create(name: "Player " + i)
        players.pushObject player
        @group.players.pushObject player
      players 

  "Qualifiers geben Dummies bei incomplete Gruppe zurück": ->
    @group.set "qualifierCount", 3
    @stub(@group, "isCompleted").returns false

    qualifiers = @group.get("qualifiers")

    assert.equals 3, qualifiers.length

  "Qualifiers: Dummies sind immer die selben Objekte": ->
    @group.set "qualifierCount", 2
    @stub(@group, "isCompleted").returns false

    qualifiers1 = @group.get("qualifiers")
    qualifiers2 = @group.get("qualifiers")

    assert.equals 2, qualifiers1.length
    assert.equals qualifiers1, qualifiers2

  "Spielplan wird korrekt erstellt, Spielanzahl stimmt bei 4,3,2 Spielern": ->
    @fillPlayers 4
    @group.generateGames()
    assert.equals 6, @group.games.get("length")

    @group.players.popObject()
    @group.generateGames()
    assert.equals 3, @group.games.get("length")

    @group.players.popObject()
    @group.generateGames()
    assert.equals 1, @group.games.get("length")
    assert.equals @group.games.objectAt(0).get("player1").name, "Player 1"
    assert.equals @group.games.objectAt(0).get("player2").name, "Player 2" 

  "Tabelle berechnen": ->
    players = @fillPlayers 3
    
    ###
     p1: tore: 2  -  gegentore: 2  - punkte: 3
     p2: tore: 5  -  gegentore: 4  - punkte: 4
     p3: tore: 3  -  gegentore: 4  - punkte: 1
    ###
    @group.generateGames()
    console.debug @group.games
    game1 = @group.games.objectAt(0)
    game1.player1 = players[0]
    game1.player2 = players[1]
    game2 = @group.games.objectAt(1)
    game2.player1 = players[0]
    game2.player2 = players[2]
    game3 = @group.games.objectAt(2)
    game3.player1 = players[1]
    game3.player2 = players[2]

    game1.setResult 1, 2
    game2.setResult 1, 0
    game3.setResult 3, 3

    erster = @group.get("table").objectAt(0)
    zweiter = @group.get("table").objectAt(1)
    dritter = @group.get("table").objectAt(2)

    assert.equals players[1], erster.player
    assert.equals players[0], zweiter.player
    assert.equals players[2], dritter.player

    assert.equals 4, erster.points
    assert.equals 3, zweiter.points
    assert.equals 1, dritter.points

    assert.equals 5, erster.goals
    assert.equals 2, zweiter.goals
    assert.equals 3, dritter.goals
    
    assert.equals 4, erster.goalsAgainst
    assert.equals 2, zweiter.goalsAgainst
    assert.equals 4, dritter.goalsAgainst

    assert.equals 1, erster.rank
    assert.equals 2, zweiter.rank
    assert.equals 3, dritter.rank

  "Tabelle berechnen, Sortierung bei Differenzgleichheit": ->
    players = @fillPlayers 3
    
    ###
        1.  p3    5 : 4   3
        2.  p2    4 : 3   3
        3.  p1    3 : 5   3
    ###    
    
    @group.generateGames()
    game1 = @group.games.objectAt(0)
    game1.player1 = players[0]
    game1.player2 = players[1]
    game2 = @group.games.objectAt(1)
    game2.player1 = players[0]
    game2.player2 = players[2]
    game3 = @group.games.objectAt(2)
    game3.player1 = players[1]
    game3.player2 = players[2]

    game1.setResult 2, 1
    game2.setResult 1, 4
    game3.setResult 3, 1


    erster = @group.get("table").objectAt(0)
    zweiter = @group.get("table").objectAt(1)
    dritter = @group.get("table").objectAt(2)

    assert.equals players[2], erster.player
    assert.equals players[1], zweiter.player
    assert.equals players[0], dritter.player

  "Tabelle berechnen, wobei noch keine Spiele absolviert wurden": ->
    players = @fillPlayers 3
    
    erster = @group.get("table").objectAt(0)
    zweiter = @group.get("table").objectAt(1)
    dritter = @group.get("table").objectAt(2)


    assert.equals 0, erster.points
    assert.equals 0, zweiter.points
    assert.equals 0, dritter.points

    assert.equals 0, erster.goals
    assert.equals 0, zweiter.goals
    assert.equals 0, dritter.goals
    
    assert.equals 0, erster.goalsAgainst
    assert.equals 0, zweiter.goalsAgainst
    assert.equals 0, dritter.goalsAgainst

  "Qualifikanten-Anzahl erhöhen (darf nicht größer als teilnehmerzahl sein)": ->
    @fillPlayers 4
    @group.set "qualifierCount", 2

    @group.increaseQualifierCount()
    assert.equals 3, @group.qualifierCount

    @group.increaseQualifierCount()
    assert.equals 4, @group.qualifierCount

    @group.increaseQualifierCount()
    assert.equals 4, @group.qualifierCount

    @group.removeLastPlayer()
    assert.equals 3, @group.qualifierCount

  "Qualifikanten-Anzahl verringern (darf nicht kleiner als 0 sein)": ->
    @fillPlayers 4
    @group.set "qualifierCount", 2

    @group.decreaseQualifierCount()
    assert.equals 1, @group.qualifierCount

    @group.decreaseQualifierCount()
    assert.equals 1, @group.qualifierCount

  "Überprüfung ob Gruppe fertig ist": ->
    @fillPlayers 4
    @group.generateGames()
    @group.set "qualifierCount", 2

    refute @group.isCompleted()

    @group.get("games").forEach (game) ->
      game.setResult 1, 2

    assert @group.isCompleted()
        
  "Vertauschen von Spielen des Spielplans": ->
    @fillPlayers 3
    @group.generateGames()
    assert 3, @group.games.get("length")

    game1 = @group.games.objectAt 0
    game2 = @group.games.objectAt 1
    game3 = @group.games.objectAt 2

    @group.swapGames 0, 1

    assert.equals @group.games.objectAt(0), game2
    assert.equals @group.games.objectAt(1), game1
    assert.equals @group.games.objectAt(2), game3

    @group.swapGames 2, 0

    assert.equals @group.games.objectAt(0), game3
    assert.equals @group.games.objectAt(1), game1
    assert.equals @group.games.objectAt(2), game2
