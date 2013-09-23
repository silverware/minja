buster.testCase "Utils",
  setUp: ->
    App.Tournament.clear()

  "Filterung der Spiele durch Schnellsuche": ->
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
      assert.equals list.length, index.length
      for i in index
        contains = list.some (item) ->
          return (item is games[i])
        assert contains

    result = App.utils.filterGames "Han", games
    assertGames result, 0, 3, 4

    result = App.utils.filterGames "aul", games
    assertGames result, 1, 2, 3

    result = App.utils.filterGames "", games
    assertGames result, 0, 1, 2, 3, 4, 5, 6

    result = App.utils.filterGames null, games
    assertGames result, 0, 1, 2, 3, 4, 5, 6

    result = App.utils.filterGames "  ", games
    assertGames result, 0, 1, 2, 3, 4, 5, 6

    result = App.utils.filterGames "han up ", games
    assertGames result, 4
    assert true

  "Filterung der Spiele durch Schnellsuche mit Custom Attributen": ->
    schiriAttr = App.GameAttribute.create
      id: "schiedsrichter"
      name: "Schiedsrichter"
      type: "textfield"

    App.Tournament.gameAttributes.pushObject schiriAttr
    create = (name) ->
      App.Player.create name: name
    games = [
      App.Game.create player1: create("Hans"), player2: create("Peter"), schiedsrichter: "Pfandel"
      App.Game.create player1: create("Hans"), player2: create("Super Star"), schiedsrichter: "Pfeifer"
      App.Game.create player1: create("Super Star"), player2: create("Peter"), schiedsrichter: ""
      App.Game.create player1: create("Thorben"), player2: create("Thorben"), schiedsrichter: "Merk"
    ]
    assertGames = (list, index...) ->
      assert.equals list.length, index.length
      for i in index
        contains = list.some (item) ->
          return (item is games[i])
        assert contains

    result = App.utils.filterGames "Han", games
    assertGames result, 0, 1
    result = App.utils.filterGames "pf", games
    assertGames result, 0, 1

    result = App.utils.filterGames "", games
    assertGames result, 0, 1, 2, 3

    result = App.utils.filterGames "merk", games
    assertGames result, 3

    result = App.utils.filterGames "pf uper", games
    assertGames result, 1
    assert true
