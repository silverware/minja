buster.testCase "Persistence",
  setUp: ->
    App.tournament.bracket.clear()
    App.tournament.participants.clear()
    App.tournament.bracket.addKoRound()
    @firstRound = App.tournament.bracket.lastRound()
    @firstRound.addItem()
    @firstRound.addItem()

    App.tournament.bracket.addKoRound()
    @secondRound = App.tournament.bracket.lastRound()
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

  "Die Properties einer Runde persistieren": ->
    round = App.KoRound.create
      name: "round"
    json = App.Serializer.emberObjToJsonData round
    assert.equals 'round', json.name
    assert.equals true, json.isKoRound
    assert.equals 0, json.items.length





