buster.testCase "Game Model"
  setUp: ->
    @hans = App.Player.create name: "Hans"
    @peter = App.Player.create name: "Peter"
    @game = App.Game.create
      player1: @hans
      player2: @peter

  "test ember obj": ->
    p1 = App.Player.create()
    p2 = App.Player.create()

    p1.isDummy = true

    assert.equals true, p1.isDummy
    assert.equals false, p2.isDummy

    p1.set("name", "hi")
    assert.equals "hi", p1.name
    assert.equals "", p2.name

  "Gewinner eines Spiels wird korrekt ermittelt": ->

  	assert.equals null, @game.getWinner()

  	@game.setResult 2, 1
  	assert.equals @hans, @game.getWinner()

  	@game.setResult 2, 2
  	assert.equals false, @game.getWinner()

  	@game.setResult 2, 3
  	assert.equals @peter, @game.getWinner()