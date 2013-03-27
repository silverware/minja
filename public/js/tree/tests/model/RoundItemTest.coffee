buster.testCase "RoundItem Model"
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

  "Spieltage werden auf Basis der Spiele und Spieleranzahl generiert", ->
  	@fillPlayers 3
  	matchdays = @group.get("matchDays")
  	assert.equals 3, matchdays.length
  	for m in matchdays
  	  assert.equals 1, m.length
  	assert.equals matchdays[0][0], @group.get("games").objectAt 0 
  	assert.equals matchdays[1][0], @group.get("games").objectAt 1 
  	assert.equals matchdays[2][0], @group.get("games").objectAt 2

  "Spieltage werden auf Basis der Spiele und Spieleranzahl generiert", ->
  	@fillPlayers 4
  	matchdays = @group.get("matchDays")
  	assert.equals 3, matchdays.length
  	for m in matchdays
  	  assert.equals 2, m.length
  	assert.equals matchdays[0][0], @group.get("games").objectAt 0 
  	assert.equals matchdays[0][1], @group.get("games").objectAt 1 
  	assert.equals matchdays[1][0], @group.get("games").objectAt 2 
  	assert.equals matchdays[1][1], @group.get("games").objectAt 3 
  	assert.equals matchdays[2][0], @group.get("games").objectAt 4 
  	assert.equals matchdays[2][1], @group.get("games").objectAt 5 
