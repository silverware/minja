App.Round = Em.Object.extend
  name: ""
  items: []
  _previousRound: null
  _editable: true
  matchesPerGame: null

  init: ->
    @_super()
    @set "items", []
    @set "matchesPerGame", 1

  games: (->
    @get("items").reduce (roundGames, item) ->
      roundGames.concat item.get("games")
    , []
  ).property('items.@each.games.@each')

  matchDays: (->
    matchDays = []
    maxMatchDays = _.max (roundItem.get("matchDayCount") for roundItem in @get("items"))
    for i in [0..maxMatchDays - 1]
      games = []
      @get("items").forEach (item) ->
        if item.get("matchDays").objectAt(i)
          games.pushObject item.get("matchDays").objectAt(i).games
      games = _.flatten _.zip.apply null, games
      games = games.filter (game) -> game
      matchDays.pushObject Em.Object.create
        games: games
        matchDay: i + 1
  ).property("items.@each.matchDays")

  editable: ((key, value) ->
    # SETTER
    if arguments.length > 1
      @set "_editable", value
    # GETTER
    @get '_editable'
  ).property('_editable')

  isEditable: (->
    (App.get('editable') and @get("editable"))
  ).property("App.editable", "editable")

  qualifiers: (->
    @get("items").reduce (qualifiers, item) ->
      qualifiers.concat item.get("qualifiers")
    , []
  ).property("items.@each.qualifiers")

  getMembers: ->
    if @get("_previousRound")
      return @get("_previousRound").get("qualifiers")
    if App.initialMembers
      return App.initialMembers
    return null

  getFreeMembers: ->
    freeMembers = null
    members = @getMembers()
    if members
      freeMembers = []
      for member in members
        if @memberNotAssigned member
          freeMembers.pushObject member
    freeMembers

  isFirstRound: =>
    !@get "_previousRound"

  isLastRound: (->
    App.tournament.bracket.lastRound() is @
  ).property("App.tournament.bracket.@each")

  validate: ->
    return (@getFreeMembers() is null or @getFreeMembers().length is 0) and @get("qualifiers").length > 1

  removeItem: (item) ->
    @items.removeObject item

  memberNotAssigned: (member) ->
    for item in @get("items")
      if _.include item.get("players"), member
        return false
    return true

  swapPlayers: (player1Index, player2Index) ->
    # playerIndex: tupel [roundIndex, Playerindex]
    gamePlayers1 = @items.objectAt(player1Index[0]).players
    gamePlayers2 = @items.objectAt(player2Index[0]).players
    if gamePlayers1 is gamePlayers2 && @isGroupRound
      return

    player1 = gamePlayers1.objectAt player1Index[1]
    player2 = gamePlayers2.objectAt player2Index[1]

    gamePlayers1.removeObject player1
    gamePlayers2.removeObject player2

    if player1Index[1] < player2Index[1]
      gamePlayers1.insertAt player1Index[1], player2
      gamePlayers2.insertAt player2Index[1], player1
    else
      gamePlayers2.insertAt player2Index[1], player1
      gamePlayers1.insertAt player1Index[1], player2

  getPlayers: ->
    _.flatten(@get('items').map (item) -> item.get('players')).filter (player) ->
      player.isPlayer

  shuffle: ->
    # TODO: echter Zufall Sequenz generator mit random.org api

    players = _.shuffle _.flatten @get('items').map (item) -> item.get('players')

    @get('items').forEach (item) ->
      for i in [0..item.get('players.length') - 1]
        item.get('players').replace i, 1, [_.last players]
        players.popObject()


  koRoundsBefore: ->
    if not @_previousRound or not @_previousRound.isKoRound
      return 0
    @_previousRound.koRoundsBefore() + 1

  ###---------------------------------------------------------------------------
    Statistics
  ---------------------------------------------------------------------------####

  gamesCount: (->
    @get('games.length')
  ).property('games')

  completion: (->
    completion = 0
    @get("items").forEach (item) -> completion += item.get("completion")
    completion
  ).property("items.@each.completion")

  isNotStarted: (->
    @get('completion') is 0
  ).property('completion')

  completionRatio: (->
    @get("completion") / @get("gamesCount") * 100
  ).property("completion", "gamesCount")
