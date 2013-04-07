buster.testCase "Round Model"
  setUp: ->
    App.Tournament.clear()
    App.Tournament.addKoRound()
    @round = App.Tournament.lastRound()


  "Zufälliges Auslosen der Spieler": ->
    getPlayers = (games) ->
      players = []
      games.forEach (game) ->
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
    assert.equals 0, _.difference initialPlayers, shuffledPlayers
