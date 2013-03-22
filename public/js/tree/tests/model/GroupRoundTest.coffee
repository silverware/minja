buster.testCase "Group Round Model"
  setUp: ->
    App.Tournament.clear()
    App.Tournament.addGroupRound()
    @round = App.Tournament.lastRound()

  "Hinzufügen einer Gruppe mit 4 Spielern": ->
    
    @round.addItem()

    assert.equals 1, @round.items.content.length
    assert.equals 4, @round.items.objectAt(0).players.content.length
