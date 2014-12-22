buster.testCase "Round Model",
  setUp: ->
    App.Tournament.clear()
    App.Tournament.addKoRound()
    @round = App.Tournament.lastRound()

  "Zufälliges Auslosen der Spieler": ->
    getPlayers = (games) ->
      players = []
      games.forEach (game) ->
        for player in game.get("players")
          players.pushObject player
      players
    @round.addItem()
    @round.addItem()
    @round.addItem()
    initialPlayers = getPlayers @round.get("items")

    assert.equals 3, @round.get 'items.length'

    @round.shuffle()

    assert.equals 3, @round.get 'items.length'
    @round.get('items').forEach (item) ->
      assert.equals 2, item.get("players.length")

    shuffledPlayers = getPlayers @round.get("items")
    assert.equals 0, _.difference(initialPlayers, shuffledPlayers).length

  "count Ko Rounds before": ->
    App.Tournament.clear()
    App.Tournament.pushObject App.KoRound.create()
    App.Tournament.pushObject App.KoRound.create
      _previousRound: App.Tournament.lastRound()
    round = App.Tournament.lastRound()

    assert.equals 1, round.koRoundsBefore()
    App.Tournament.pushObject App.KoRound.create
      _previousRound: App.Tournament.lastRound()
    round = App.Tournament.lastRound()
    assert.equals 2, round.koRoundsBefore()
    App.Tournament.pushObject App.GroupRound.create
      _previousRound: App.Tournament.lastRound()
    App.Tournament.pushObject App.KoRound.create
      _previousRound: App.Tournament.lastRound()
    App.Tournament.pushObject App.KoRound.create
      _previousRound: App.Tournament.lastRound()
    round = App.Tournament.lastRound()
    assert.equals 1, round.koRoundsBefore()

  "swap players in group round": ->
    round = App.GroupRound.create()
    group1 = App.Group.create
      _round: round
    group2 = App.Group.create
      _round: round

    round.items.pushObject group1
    round.items.pushObject group2

    p1 = App.Player.create(name: "Player 1")
    p2 = App.Player.create(name: "Player 2")
    p3 = App.Player.create(name: "Player 3")
    p4 = App.Player.create(name: "Player 4")

    group1.players.pushObject p1
    group1.players.pushObject p2
    group2.players.pushObject p3
    group2.players.pushObject p4

    round.swapPlayers [0,1], [1,0]

    assert.equals group1.players[0], p1
    assert.equals group1.players[1], p3
    assert.equals group2.players[0], p2
    assert.equals group2.players[1], p4


    # no change, if players belong to same group
    round.swapPlayers [0,1], [0,0]

    assert.equals group1.players[0], p1
    assert.equals group1.players[1], p3
    assert.equals group2.players[0], p2
    assert.equals group2.players[1], p4

  "swap players in ko round": ->
    game1 = App.RoundGame.create
      _round: @round
    game2 = App.RoundGame.create
      _round: @round

    @round.items.pushObject game1
    @round.items.pushObject game2
    p1 = App.Player.create name: "p1"
    p2 = App.Player.create name: "p2"
    p3 = App.Player.create name: "p3"
    p4 = App.Player.create name: "p4"
    game1.players.pushObject p1
    game1.players.pushObject p2
    game2.players.pushObject p3
    game2.players.pushObject p4

    @round.swapPlayers [0,1], [1,0]

    assert.equals game1.players[0], p1
    assert.equals game1.players[1], p3
    assert.equals game2.players[0], p2
    assert.equals game2.players[1], p4


    @round.swapPlayers [0,1], [0,0]

    assert.equals game1.players[0], p3
    assert.equals game1.players[1], p1
    assert.equals game2.players[0], p2
    assert.equals game2.players[1], p4

    @round.swapPlayers [0,0], [0,1]

    assert.equals game1.players[0], p1
    assert.equals game1.players[1], p3

  "get Games by Player": ->
    game1 = App.RoundGame.create
      _round: @round
    game2 = App.RoundGame.create
      _round: @round

    @round.items.pushObject game1
    @round.items.pushObject game2
    p1 = App.Player.create name: "p1"
    p2 = App.Player.create name: "p2"
    p3 = App.Player.create name: "p3"
    p4 = App.Player.create name: "p4"
    game1.players.pushObject p1
    game1.players.pushObject p2
    game2.players.pushObject p3
    game2.players.pushObject p4


    App.Tournament.addKoRound()
    lastRound = App.Tournament.lastRound()

    game3 = App.RoundGame.create
      _round: lastRound

    lastRound.items.pushObject game3
    game3.players.pushObject p1
    game3.players.pushObject p3

    rounds = App.Tournament.getGamesByPlayer p1
    assert.equals game1.get('games').objectAt(0), rounds[0].games[0]
    assert.equals game3.get('games').objectAt(0), rounds[1].games[0]

  "get Players": ->
    game1 = App.RoundGame.create
      _round: @round
    game2 = App.RoundGame.create
      _round: @round

    @round.items.pushObject game1
    @round.items.pushObject game2
    p1 = App.Player.create name: "p1"
    p2 = App.Player.create name: "p2"
    p3 = App.Player.create name: "p3"
    p4 = App.Player.create name: "p4"
    p5 = App.Player.create name: "p5"
    game1.players.pushObject p1
    game1.players.pushObject p2
    game2.players.pushObject p3
    game2.players.pushObject p4


    App.Tournament.addGroupRound()
    lastRound = App.Tournament.lastRound()

    group = App.Group.create
      _round: lastRound

    lastRound.items.pushObject group
    group.players.pushObject p5
    group.players.pushObject App.Dummy.create()

    players = App.Tournament.getPlayers()
    assert.equals 5, players.length
    assert.equals p1, players[0]
    assert.equals p2, players[1]
    assert.equals p3, players[2]
    assert.equals p4, players[3]
    assert.equals p5, players[4]
