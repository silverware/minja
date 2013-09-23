buster.testCase "Persistence",
  setUp: ->
    App.Tournament.clear()
    App.Tournament.addKoRound()

  "Turnier wird mit einer leeren KO-Runde persistiert": ->
    App.PersistanceManager.persist App.Tournament
    assert true





