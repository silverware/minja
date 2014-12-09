App.PersistanceManager =

  dummies: []

  persist: ->
    members: @persistPlayers()
    tree: @persistTree()

  persistPlayers: ->
    App.Serializer.emberObjArrToJsonDataArr App.PlayerPool.filterOutTemporaryPlayers()

  persistTree: ->
    tournament = App.Tournament
    serialized = App.Serializer.emberObjToJsonData tournament
    serialized.rounds = []
    for round in tournament.content
       serialized.rounds.push App.Serializer.emberObjToJsonData round
    serialized

  extend: (target, source) ->
    target.set(name, method) for name, method of source
    for key, value of target
      if typeof value is 'string'
        if value is 'false'
          target.set key, false
        if value is 'true'
          target.set key, true
        if value is 'null'
          target.set key, null

  removeValue: (obj, key) ->
    value = _.pick obj, key
    delete obj[key]
    value[key]

  build: (obj) ->
    if not obj?.rounds then return
    tournamentRounds = @removeValue obj, "rounds"
    gameAttributes = @removeValue obj, "gameAttributes"
    @extend App.Tournament, obj
    App.Tournament.clear()
    for round in tournamentRounds
      if round.isGroupRound
        gRound = App.Tournament.addGroupRound()
        roundItems = @removeValue round, "items"
        @extend gRound, round
        for item in roundItems
          gRound.items.pushObject @buildGroup item, gRound
      if round.isKoRound
        kRound = App.Tournament.addKoRound()
        roundItems = @removeValue round, "items"
        @extend kRound, round
        for item in roundItems
          kRound.items.pushObject @buildRoundGame item, kRound
    for gameAttribute in gameAttributes
      App.Tournament.gameAttributes.pushObject App.GameAttribute.create gameAttribute

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
      roundItem.dummies.pushObject @createPlayer dummy
    for player in obj.players
      roundItem.players.pushObject @createPlayer player
    roundItem.games.clear()
    for game in obj.games
      roundItem.games.pushObject @buildGame game
    delete obj.games
    delete obj.dummies
    delete obj.players
    @extend roundItem, obj

  isTrue: (obj) ->
    return obj and obj isnt "false"

  createPlayer: (obj) ->
    return dummy for dummy in @dummies when dummy.id is obj.id
    newPlayer = if @isTrue(obj.isDummy) then App.Dummy.create(obj) else App.PlayerPool.getPlayerById obj.id
    newPlayer.set "id", obj.id
    @extend newPlayer, {}
    if newPlayer.isDummy
      @dummies.pushObject newPlayer
    newPlayer
