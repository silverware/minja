buster.testCase "Round Model"
  setUp: ->
    App.Tournament.clear()
    App.Tournament.addKoRound()
    @round = App.Tournament.lastRound()

  "Zufälliges Auslosen der Spieler": ->
    getPlayers = (games) ->
      players = []
      games.forEach (game) ->
        console.debug game
        for player in game.get("players")
          players.pushObject player
      players
    @round.addItem()
    @round.addItem()
    @round.addItem()
    initialPlayers = getPlayers @round.get("items")

    assert.equals 3, @round.get 'items.length'

    @round.shuffle()

    assert.equals 3, @round.get 'items.length'
    @round.get('items').forEach (item) ->
      assert.equals 2, item.get("players.length")

    shuffledPlayers = getPlayers @round.get("items")
    assert.equals 0, _.difference(initialPlayers, shuffledPlayers).length

  "count Ko Rounds before": ->
    App.Tournament.clear()
    App.Tournament.pushObject App.KoRound.create()
    App.Tournament.pushObject App.KoRound.create
      _previousRound: App.Tournament.lastRound()
    round = App.Tournament.lastRound()
    console.debug App.Tournament
    assert.equals 1, round.koRoundsBefore()
    App.Tournament.pushObject App.KoRound.create
      _previousRound: App.Tournament.lastRound()
    round = App.Tournament.lastRound()
    assert.equals 2, round.koRoundsBefore()
    App.Tournament.pushObject App.GroupRound.create
      _previousRound: App.Tournament.lastRound()
    App.Tournament.pushObject App.KoRound.create
      _previousRound: App.Tournament.lastRound()
    App.Tournament.pushObject App.KoRound.create
      _previousRound: App.Tournament.lastRound()
    round = App.Tournament.lastRound()
    assert.equals 1, round.koRoundsBefore()