buster.testCase "RoundItem Model"
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
      assert.equals 1, m.length
    assert.equals matchdays[0][0].game, @group.get("games").objectAt 0 
    assert.equals matchdays[1][0].game, @group.get("games").objectAt 1 
    assert.equals matchdays[2][0].game, @group.get("games").objectAt 2
    assert.equals matchdays[0][0].matchDay, 1 
    assert.equals matchdays[1][0].matchDay, 2 
    assert.equals matchdays[2][0].matchDay, 3

  "Spieltage werden auf Basis der Spiele und der Spieleranzahl generiert: 4 Spieler": ->
    @fillPlayers 4
    matchdays = @group.get("matchDays")
    assert.equals 3, matchdays.length
    for m in matchdays
      assert.equals 2, m.length
    assert.equals matchdays[0][0].game, @group.get("games").objectAt 0 
    assert.equals matchdays[0][1].game, @group.get("games").objectAt 1 
    assert.equals matchdays[1][0].game, @group.get("games").objectAt 2 
    assert.equals matchdays[1][1].game, @group.get("games").objectAt 3 
    assert.equals matchdays[2][0].game, @group.get("games").objectAt 4 
    assert.equals matchdays[2][1].game, @group.get("games").objectAt 5 

  "Spieltage werden auf Basis der Spiele und Spieleranzahl generiert: 3 Spieler, 2 Spiele/Begegnung": ->
    @fillPlayers 3
    @round.set "matchesPerGame", 2
    matchdays = @group.get("matchDays")
    assert.equals 6, matchdays.length
    for m in matchdays
      assert.equals 1, m.length
    assert.equals matchdays[0][0].game, @group.get("games").objectAt 0 
    assert.equals matchdays[1][0].game, @group.get("games").objectAt 1 
    assert.equals matchdays[2][0].game, @group.get("games").objectAt 2
    assert.equals matchdays[3][0].game, @group.get("games").objectAt 3
    assert.equals matchdays[4][0].game, @group.get("games").objectAt 4
    assert.equals matchdays[5][0].game, @group.get("games").objectAt 5
