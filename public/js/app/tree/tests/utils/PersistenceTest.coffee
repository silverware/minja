buster.testCase "Persistence",
  setUp: ->
    App.Tournament.clear()
    App.PlayerPool.clear()
    App.Tournament.addKoRound()
    @firstRound = App.Tournament.lastRound()
    @firstRound.addItem()
    @firstRound.addItem()

    App.Tournament.addKoRound()
    @secondRound = App.Tournament.lastRound()
    @secondRound.addItem()

  "Turnier wird persistiert ohne Fehler": ->
    serialized = App.PersistanceManager.persist()
    assert true

  "Die Teilnehmer des Turniers werden korrekt persistiert": ->
    serialized = App.PersistanceManager.persist()
    members = serialized.members
    tree = serialized.tree
    assert.equals 4, members.length
    assert.equals 2, tree.rounds.length
    assert.equals 2, tree.rounds[0].items.length
    assert.equals 1, tree.rounds[1].items.length






