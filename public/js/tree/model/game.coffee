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

  getPoints: (playerNumber) ->
    winPoints = parseInt App.Tournament.get("winPoints")
    drawPoints = parseInt App.Tournament.get("drawPoints")
    if not @get("isCompleted")
      return 0
    if playerNumber is 1
      if @result1 > @result2
        return winPoints
      else if @result1 < @result2
        return 0
    if playerNumber is 2
      if @result2 > @result1
        return winPoints
      else if @result2 < @result1
        return 0

    return drawPoints