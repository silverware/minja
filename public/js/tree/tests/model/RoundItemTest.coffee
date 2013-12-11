buster.testCase "RoundItem Model",
  setUp: ->
    @round = App.GroupRound.create()
    @group = App.Group.create
      _round: @round
    @fillPlayers = (count) =>
      for i in [1..count]
        player = App.Player.create(name: "Player " + i)
        @group.players.pushObject player
    null

  "Spieltage werden auf Basis der Spiele und Spieleranzahl generiert: 3 Spieler": ->
    @fillPlayers 3
    matchdays = @group.get("matchDays")
    assert.equals 3, matchdays.length
    for m in matchdays
      assert.equals 1, m.games.length
    assert.equals matchdays[0].games[0], @group.get("games").objectAt 0
    assert.equals matchdays[1].games[0], @group.get("games").objectAt 1
    assert.equals matchdays[2].games[0], @group.get("games").objectAt 2
    assert.equals matchdays[0].matchDay, 1
    assert.equals matchdays[1].matchDay, 2
    assert.equals matchdays[2].matchDay, 3

    assert.equals 3, @group.get("matchDayCount")

  "Spieltage werden auf Basis der Spiele und der Spieleranzahl generiert: 4 Spieler": ->
    @fillPlayers 4
    matchdays = @group.get("matchDays")
    assert.equals 3, matchdays.length
    for m in matchdays
      assert.equals 2, m.games.length
    assert.equals matchdays[0].games[0], @group.get("games").objectAt 0
    assert.equals matchdays[0].games[1], @group.get("games").objectAt 1
    assert.equals matchdays[1].games[0], @group.get("games").objectAt 2
    assert.equals matchdays[1].games[1], @group.get("games").objectAt 3
    assert.equals matchdays[2].games[0], @group.get("games").objectAt 4
    assert.equals matchdays[2].games[1], @group.get("games").objectAt 5
    assert.equals 3, @group.get("matchDayCount")

  "Spieltage werden auf Basis der Spiele und Spieleranzahl generiert: 3 Spieler, 2 Spiele/Begegnung": ->
    @fillPlayers 3
    @round.set "matchesPerGame", 2
    matchdays = @group.get("matchDays")
    assert.equals 6, matchdays.length
    for m in matchdays
      assert.equals 1, m.games.length
    assert.equals matchdays[0].games[0], @group.get("games").objectAt 0
    assert.equals matchdays[1].games[0], @group.get("games").objectAt 1
    assert.equals matchdays[2].games[0], @group.get("games").objectAt 2
    assert.equals matchdays[3].games[0], @group.get("games").objectAt 3
    assert.equals matchdays[4].games[0], @group.get("games").objectAt 4
    assert.equals matchdays[5].games[0], @group.get("games").objectAt 5
    assert.equals 6, @group.get("matchDayCount")

  "Die Anzahl der absolvierten Spiele wird korrekt ermittelt": ->
    @fillPlayers 3
    @round.set "matchesPerGame", 2
    completed = @group.get("completion")
    assert.equals 0, completed
    game1 = @group.games.objectAt(0)
    game2 = @group.games.objectAt(1)
    game3 = @group.games.objectAt(2)

    game1.setResult 1, 2
    game2.setResult 1, 0
    game3.setResult 3, 3

    assert.equals 3, @group.get("completion")

  "Berechnung der Id eines RoundItems": ->
    App.Tournament.clear()
    round1 = App.Tournament.addKoRound()
    round1.addItem()
    round1.addItem()
    round2 = App.Tournament.addGroupRound()
    round2.addItem()

    game1 = round1.get('items')[0]
    game2 = round1.get('items')[1]
    game3 = round2.get('items')[0]

    assert.equals '0-0', game1.get 'itemId'
    assert.equals '0-1', game2.get 'itemId'
    assert.equals '1-0', game3.get 'itemId'
