buster.testCase "Utils",
  setUp: ->
    App.tournament.bracket.clear()

  "Filterung der Spiele nach gespielten und nicht gespielten": ->
    create = (name) ->
      App.Player.create name: name
    games = [
      App.Game.create player1: create("Hans"), player2: create("Peter"), result1: 2, result2: 1
      App.Game.create player1: create("Paul"), player2: create("Peter")
      App.Game.create player1: create("Paul"), player2: create("Peter")
      App.Game.create player1: create("Hans"), player2: create("Paul")
      App.Game.create player1: create("Hans"), player2: create("Super Star")
      App.Game.create player1: create("Super Star"), player2: create("Peter")
      App.Game.create player1: create("Thorben"), player2: create("Thorben"), result1: 1, result2: 3
    ]

    assertGames = (list, index...) ->
      assert.equals list.length, index.length
      for i in index
        contains = list.some (item) ->
          return (item is games[i])
        assert contains

    console.debug "compledted", games[6].get("isCompleted")

    result = App.utils.filterGames {search: "", played: true}, games
    assertGames result, 0, 6

    result = App.utils.filterGames {search: "", played: false}, games
    assertGames result, 1, 2, 3, 4, 5

    result = App.utils.filterGames {search: "Han", played: true}, games
    assertGames result, 0

    result = App.utils.filterGames {search: "Han", played: null}, games
    assertGames result, 0, 3, 4

    result = App.utils.filterGames {search: "Han", played: false}, games
    assertGames result, 3, 4

    assert true

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

    result = App.utils.filterGames search: "Han", games
    assertGames result, 0, 3, 4

    result = App.utils.filterGames search: "aul", games
    assertGames result, 1, 2, 3

    result = App.utils.filterGames search: "", games
    assertGames result, 0, 1, 2, 3, 4, 5, 6

    result = App.utils.filterGames null, games
    assertGames result, 0, 1, 2, 3, 4, 5, 6

    result = App.utils.filterGames search: "  ", games
    assertGames result, 0, 1, 2, 3, 4, 5, 6

    result = App.utils.filterGames search: "han up ", games
    assertGames result, 4
    assert true

  "Filterung der Spiele durch Schnellsuche mit Custom Attributen": ->
    schiriAttr = App.GameAttribute.create
      id: "schiedsrichter"
      name: "Schiedsrichter"
      type: "textfield"

    App.tournament.bracket.gameAttributes.pushObject schiriAttr
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

    result = App.utils.filterGames search: "Han", games
    assertGames result, 0, 1
    result = App.utils.filterGames search: "pf", games
    assertGames result, 0, 1

    result = App.utils.filterGames search: "", games
    assertGames result, 0, 1, 2, 3

    result = App.utils.filterGames search: "merk", games
    assertGames result, 3

    result = App.utils.filterGames search: "pf uper", games
    assertGames result, 1
    assert true
