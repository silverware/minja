buster.testCase "Group Round Model"
  setUp: ->
    App.Tournament.clear()
    App.Tournament.addGroupRound()
    @round = App.Tournament.lastRound()

  "Hinzufügen einer Gruppe mit 4 Spielern": ->
    
    @round.addItem()

    assert.equals 1, @round.items.content.length
    assert.equals 4, @round.items.objectAt(0).players.get("length")

  "Spieltage werden gezippt bei gleichbleibender Spieltagszahl": ->
    @round.addItem()
    @round.addItem()
    @round.items.forEach (group) ->
      group.removeLastPlayer()

    group1 = @round.get("items").objectAt 0
    group2 = @round.get("items").objectAt 1

    matchdays = @round.get("matchDays")
    assert.equals 3, matchdays.length
    for m in matchdays
      assert.equals 2, m.games.length
    assert.equals matchdays[0].games[0], group1.get("games").objectAt 0
    assert.equals matchdays[0].games[1], group2.get("games").objectAt 0 
    assert.equals matchdays[1].games[0], group1.get("games").objectAt 1 
    assert.equals matchdays[1].games[1], group2.get("games").objectAt 1 
    assert.equals matchdays[2].games[0], group1.get("games").objectAt 2
    assert.equals matchdays[2].games[1], group2.get("games").objectAt 2
    assert.equals matchdays[0].matchDay, 1 
    assert.equals matchdays[1].matchDay, 2 
    assert.equals matchdays[2].matchDay, 3

  "Spieltage werden gezippt bei unterschiedlicher Spieltagszahl": ->
    assert false