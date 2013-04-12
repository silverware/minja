App.Game = Em.Object.extend
  player1: null
  player2: null
  result1: null
  result2: null
  date: null
  attributes: []

  isCompleted: (->
    (@get("result1") or @get("result1") == 0) and (@get("result2") or @get("result2") == 0)
  ).property("result1", "result2")

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

  getWinner: ->
    if not @get("isCompleted") then return null
    if @get("goals1") > @get("goals2") then return @get("player1")
    if @get("goals1") < @get("goals2") then return @get("player2")
    if @get("goals1") is @get("goals2") then return false


  getPoints: (playerNumber) ->
    winPoints = parseInt App.Tournament.get("winPoints")
    drawPoints = parseInt App.Tournament.get("drawPoints")
    if not @get("isCompleted") then return 0

    player = @get("player#{playerNumber}")
    winner = @getWinner()

    if not winner then return drawPoints
    if player is winner then return winPoints
    if player isnt winner then return 0