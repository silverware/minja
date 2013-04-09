App.Group = App.RoundItem.extend
  isGroup: true
  qualifierCount: null
  _tempQualifiers: []

  qualifiers: (->
    qualifiers = []
    if !@isCompleted()
      for i in [1..@get("qualifierCount")]
        index = i - 1 
        if !@dummies[index]
          @dummies[index] = App.Dummy.create()
        @dummies[index].set "name", i + ". " + @get("name")
        if @_tempQualifiers[index]? and not @_tempQualifiers[index].isDummy
          @replace @_tempQualifiers[index], @dummies[index]
        qualifiers.pushObject @dummies[index]
    else
      for i in [0..@get("qualifierCount") - 1]
        player = @get("table").objectAt(i).player
        qualifiers.pushObject player
        @replace @dummies[i], player
    @_tempQualifiers = qualifiers
    qualifiers
    ).property("qualifierCount", "games.@each.isCompleted", "name")

  init: ->
    @_super()
    @set "qualifierCount", 2

  removeLastPlayer: ->
    if @get("players.length") > 2
      @get("players").popObject()
    @onPlayerSizeChange()

  addPlayer: ->
    freeMembers = @get("_round").getFreeMembers()
    if freeMembers?.length > 0
      @get("players").pushObject freeMembers[0]
    else
      @get("players").pushObject App.Player.create
        name: "Player"
    @onPlayerSizeChange()
 
  table: (->
    players = []
    # befüllen
    for index in [0..@get("players.length") - 1]
      player = @get("players").objectAt index
      stats = @calculateStats player
      players.pushObject Em.Object.create
        player: player
        index: index
        games: stats.games
        points: stats.points
        goals: stats.goals
        goalsAgainst: stats.goalsAgainst
        difference: stats.difference

    # Sortieren 
    sorted = players.sort (a, b) ->
      greater = b.points - a.points
      if greater == 0
        greater = b.difference - a.difference
        if greater == 0
          greater = b.goals - a.goals
      return greater

    # Rang festlegen  
    for index in [1..sorted.length]
      sorted[index - 1].rank = index
      sorted[index - 1].qualified = index <= @get("qualifierCount")

    sorted
  ).property("players.@each", "qualifierCount", "games.@each.result1", "games.@each.result2", "App.Tournament.winPoints", "App.Tournament.drawPoints")   

  generateGames: (->
    @_round.set "changes", @_round.get("changes") + 1
    @games.clear()
    games = App.RoundRobin.generateGames @get("players")

    for i in [1..@get("_round.matchesPerGame")]
      for game in games
        p1 = game[0]
        p2 = game[1]
        if i % 2 is 0 then [p1, p2] = [p2, p1]
        @games.pushObject App.Game.create
          player1: p1
          player2: p2
  ).observes("players.@each", "_round.matchesPerGame")

  isCompleted: ->
    @get("games").every (game) -> game.get("isCompleted")

  increaseQualifierCount: -> 
    if @get("players.length") > @qualifierCount
      @set "qualifierCount", @qualifierCount + 1

  decreaseQualifierCount: ->
    if @qualifierCount > 1
      @set "qualifierCount", @qualifierCount - 1

  onPlayerSizeChange: ->
    if @get("players.length") < @qualifierCount
      @set "qualifierCount", @get('players.length')

  calculateStats: (player) ->
    stats =
      points: 0
      games: 0
      goals: 0
      goalsAgainst: 0
      difference: 0

    @games.forEach (game) ->
      if player is game.get("player1")
        stats.goals += game.get("goals1")
        stats.goalsAgainst += game.get("goals2")
        stats.points += game.getPoints 1
        stats.games += 1 if game.get("isCompleted")
      if player is game.get("player2")
          stats.goals += game.get("goals2")
          stats.goalsAgainst += game.get("goals1")
          stats.points += game.getPoints 2
          stats.games += 1 if game.get("isCompleted")
    stats.difference = stats.goals - stats.goalsAgainst
    stats

  swapGames: (gameIndex1, gameIndex2) ->
    fromGame = @games.objectAt gameIndex1
    toGame = @games.objectAt gameIndex2
    content = @games
    content[gameIndex1] = toGame
    content[gameIndex2] = fromGame

    # zum aktualisieren des Views
    game = @games.objectAt gameIndex1
    @games.removeObject game
    @games.insertAt gameIndex1, game