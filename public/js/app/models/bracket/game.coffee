App.Game = Em.Object.extend

  player1: null
  player2: null
  result1: null
  result2: null
  date: null
  _playersSwapped: true

  isCompleted: (->
    (@get("result1") or @get("result1") == 0) and (@get("result2") or @get("result2") == 0)
  ).property("result1", "result2")

  players: (->
    [@player1, @player2]
  ).property('player1', 'player2')

  goals1: (->
    return parseInt(@get("result1")) if @get("result1")
    return null
  ).property("result1")

  goals2: (->
    return parseInt(@get("result2")) if @get("result2")
    return null
  ).property("result2")

  setResult: (r1, r2) ->
    @set "result1", r1
    @set "result2", r2

  getGoalsByPlayer: (player) ->
    if player is @player1 then return @get("goals1")
    if player is @player2 then return @get("goals2")

  getGoalsAgainstByPlayer: (player) ->
    if player is @player1 then return @get("goals2")
    if player is @player2 then return @get("goals1")

  getWinner: ->
    if not @get("isCompleted") then return null
    if @get("goals1") > @get("goals2") then return @get("player1")
    if @get("goals1") < @get("goals2") then return @get("player2")
    if @get("goals1") is @get("goals2") then return false

  player1Wins: (->
    @getWinner() is @get("player1")
  ).property('isCompleted', 'player1')

  player2Wins: (->
    @getWinner() is @get("player2")
  ).property('isCompleted', 'player2')

  getPoints: (playerNumber) ->
    winPoints = parseInt App.Tournament.Bracket.get "winPoints"
    drawPoints = parseInt App.Tournament.Bracket.get "drawPoints"
    if not @get("isCompleted") then return 0

    player = @get "player#{playerNumber}"
    winner = @getWinner()

    if not winner then return drawPoints
    if player is winner then return winPoints
    if player isnt winner then return 0

  swapPlayers: ->
    tempPlayer = @get 'player1'
    @set 'player1', @get 'player2'
    @set 'player2', tempPlayer

    tempResult = @get 'result1'
    @set 'result1', @get 'result2'
    @set 'result2', tempResult

    # swap result attributes

    for gameAttribute in App.Tournament.Bracket.gameAttributes when gameAttribute.type is 'result'
      id = gameAttribute.get 'id'
      value = @get id
      if value?.search /:/ isnt -1
        results = value.split ':'
        @set id, results[1] + ':' + results[0]
    
    @set '_playersSwapped', not @get '_playersSwapped'
