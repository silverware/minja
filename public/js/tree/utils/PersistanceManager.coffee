App.PersistanceManager =

  players: []

  persist: (tournament) ->
    serialized = App.Serializer.emberObjToJsonData tournament
    serialized.rounds = []
    for round in tournament.content
       serialized.rounds.push App.Serializer.emberObjToJsonData(round)
    serialized

  extend: (target, source) ->
    target[name] = method for name, method of source
    for key, value of target
      if typeof value == 'string'
        if value is 'false'
          target.set key, false
        if value is 'true'
          target.set key, true
        if value is 'null'
          target.set key, null

  build: (obj) ->
    if not obj?.rounds then return
    for round in obj.rounds
      if round.isGroupRound
        gRound = App.Tournament.addGroupRound()
        for item in round.items
          gRound.items.pushObject @buildGroup item, gRound
        delete round.items
        @extend gRound, round
      if round.isKoRound
        kRound = App.Tournament.addKoRound()
        for item in round.items
          kRound.items.pushObject @buildRoundGame item, kRound
        delete round.items
        @extend kRound, round
    delete obj.rounds
    for gameAttribute in obj.gameAttributes
      App.Tournament.gameAttributes.pushObject App.GameAttribute.create gameAttribute
    delete obj.gameAttributes
    @extend App.Tournament, obj

  buildGroup: (obj, round) ->
    group = App.Group.create
      _round: round
    @buildRoundItem group, obj
    group

  buildRoundGame: (obj, round) ->
    roundGame = App.RoundGame.create
      _round: round
    @buildRoundItem roundGame, obj
    roundGame

  buildGame: (obj) ->
    game = App.Game.create
      player1: @createPlayer obj.player1
      player2: @createPlayer obj.player2
    delete obj.player1
    delete obj.player2
    @extend game, obj
    game

  buildRoundItem: (roundItem, obj) ->
    roundItem.dummies.clear()
    for dummy in obj.dummies
      roundItem.dummies.pushObject @createPlayer(dummy)
    for player in obj.players
      roundItem.players.pushObject @createPlayer(player)
    roundItem.games.clear()
    for game in obj.games
      roundItem.games.pushObject @buildGame game
    delete obj.games
    delete obj.dummies
    delete obj.players
    @extend roundItem, obj

  createPlayer: (obj) ->
    return player for player in @players when player.id is obj.id
    newPlayer = if obj.isDummy == "true" then App.Dummy.create(obj) else App.Player.create(obj)
    newPlayer.set "id", obj.id
    @extend newPlayer, {}
    @players.pushObject newPlayer
    newPlayer
