buster.testCase "Game Model"

  setUp: ->
    @round = App.KoRound.create()
    @roundGame = App.RoundGame.create
      _round: @round
    @p1 = App.Player.create name: "p1"
    @p2 = App.Player.create name: "p2"
    @roundGame.players.pushObject @p1
    @roundGame.players.pushObject @p2

  "Spieler 1 und Spieler 2 werden korrekt geholt": ->
    player1 = @roundGame.get "player1"
    player2 = @roundGame.get "player2"

    assert.equals @p1, player1
    assert.equals @p2, player2

  "Qualifiers: Dummy is immer das selbe Objekt": ->
    @stub(@roundGame, "isCompleted").returns false

    qualifier1 = @roundGame.get("qualifiers")
    qualifier2 = @roundGame.get("qualifiers")

    assert.equals 1, qualifier1.length
    assert.equals qualifier1, qualifier2

  "Qualifiers: ": ->
    dummy = @roundGame.get("qualifiers")[0]

    game = @roundGame.get("games").objectAt(0)
    assert dummy.isDummy

    game.setResult 2, 1

    player = @roundGame.get("qualifiers")[0]
    refute.equals dummy, player


  "Überprüfung ob Spiel fertig ist": ->
    @roundGame.games.pushObject App.Game.create()

    refute @roundGame.isCompleted()

    game1 = @roundGame.games.objectAt 0
    game2 = @roundGame.games.objectAt 1
    game1.set "result1", 2

    refute @roundGame.isCompleted()

    game1.set "result2", 1
    refute @roundGame.isCompleted()

    game2.setResult 2, 2

    assert @roundGame.isCompleted()

  "Gewinner aus einem Result wird ermittelt": ->
    game1 = @roundGame.games.objectAt 0
    game1.setResult 2, 1
    console.debug @roundGame.getWinner()
    assert.equals @p1, @roundGame.getWinner()

    game1.setResult 1, 2

    assert.equals @p2, @roundGame.getWinner()
  
  "Gewinner aus zwei Results wird ermittelt": ->
    @roundGame.games.pushObject App.Game.create
      player1: @p1
      player2: @p2
    game1 = @roundGame.games.objectAt(0)
    game2 = @roundGame.games.objectAt(1)
    
    game1.setResult 2, 1
    game2.setResult 2, 1

    assert.equals @p1, @roundGame.getWinner()

    game1.setResult 1, 2
    game2.setResult 3, 1

    assert.equals @p1, @roundGame.getWinner()

    game1.setResult 1, 4
    game2.setResult 3, 1

    assert.equals @p2, @roundGame.getWinner()

    game1.setResult 2, 0
    game2.setResult 1, 3

    assert.equals @p1, @roundGame.getWinner()

  "Tore werden richtig geparst": ->
    game = @roundGame.games.objectAt(0)


    assert.isNull game.get("goals1")
    assert.isNull game.get("goals2")

    game.set("result1", "2")
    game.set("result2", "1")

    assert.equals 2, game.get("goals1")
    assert.equals 1, game.get("goals2")

  "Anzahl der Results ändern": ->
    @round.set("matchesPerGame", 3)

    assert.equals 3, @roundGame.games.get("length")

    @round.set("matchesPerGame", 1)
    assert.equals 1, @roundGame.games.get("length")



