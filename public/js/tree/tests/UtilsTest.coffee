buster.testCase "Utils"
  "Spiele werden durch Schnellsuche-String gefiltert": ->
    create = (name) ->
      App.Player.create name: name
    games = [
      App.Game.create player1: create("Hans"), player2: create("Peter")
      App.Game.create player1: create("Paul"), player2: create("Peter")
      App.Game.create player1: create("Paul"), player2: create("Peter")
      App.Game.create player1: create("Hans"), player2: create("Paul")
      App.Game.create player1: create("Hans"), player2: create("Super Star")
      App.Game.create player1: create("Super Star"), player2: create("Peter")
      App.Game.create player1: create("Thorben"), player2: create("Thorben")
    ]
    assertGames = (list, index...) ->
      # TODO
      
    result = App.Utils.filterGames "han", @games
    assertGames result, 0, 3, 4





