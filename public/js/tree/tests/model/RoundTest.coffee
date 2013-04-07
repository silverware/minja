buster.testCase "Round Model"
  setUp: ->
    App.Tournament.clear()
    App.Tournament.addKoRound()
    @round = App.Tournament.lastRound()

  "Zufälliges Auslosen der Spieler": ->
    @round.addItem()
    @round.addItem()
    @round.addItem()

    assert.equals 3, @round.get 'games.length'
    assert true
