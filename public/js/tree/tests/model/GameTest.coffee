buster.testCase "Game Model"
  setUp: ->
    @hans = App.Player.create name: "Hans"
    @peter = App.Player.create name: "Peter"
    @game = App.Game.create
      player1: @hans
      player2: @peter

  "Gewinner eines Spiels wird korrekt ermittelt": ->

  	assert.equals null, @game.getWinner()

  	@game.setResult 2, 1
  	assert.equals @hans, @game.getWinner()

  	@game.setResult 2, 2
  	assert.equals false, @game.getWinner()

  	@game.setResult 2, 3
  	assert.equals @peter, @game.getWinner()