buster.testCase "Persistence",
  setUp: ->
    App.Tournament.clear()
    App.Tournament.addKoRound()

  "Turnier wird mit einer leeren KO-Runde persistiert": ->
    serialized = App.PersistanceManager.persist App.Tournament
    assert.equals undefined, serialized.content
    assert true






