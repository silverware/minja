App.RoundGame = App.RoundItem.extend
  isGame: true

  player1: (->
    @get("players").objectAt 0
    ).property("players.@each")
  
  player2: (->
    @get("players").objectAt 1
    ).property("players.@each")
  
  winnerDummy: (->
    @get("dummies").objectAt 0
  ).property("dummies.@each")

  qualifiers: (->
    if !@isCompleted()
      @get("winnerDummy").set "name", "#{App.i18n.winner} " + @get("name")
      @replace @get("player1"), @get("winnerDummy")
      @replace @get("player2"), @get("winnerDummy")
      return @dummies
    else
      winner = @getWinner()
      @replace @get("winnerDummy"), winner
      @replace @get("player1"), winner
      @replace @get("player2"), winner
      return [winner]
  ).property("players.@each", "games.@each.result1", "games.@each.result2", "name")

  
  init: ->
    @_super()
    @dummies.pushObject App.Dummy.create()

  getWinner: ->
    goalsPlayer1 = 0
    goalsPlayer2 = 0
    @games.forEach (game) =>
      goalsPlayer1 += game.getGoalsByPlayer @get("player1")
      goalsPlayer2 += game.getGoalsByPlayer @get("player2")
    if goalsPlayer2 > goalsPlayer1 then @get("player2") else @get("player1")

  isCompleted: ->
    @games.every (game) -> game.get("isCompleted")

  generateGames: (->
    @get("games").clear()
    for i in [1..@get("_round").get("matchesPerGame")]
      p1 = @get("player1")
      p2 = @get("player2")
      if i % 2 is 0 then [p1, p2] = [p2, p1]
      @get("games").pushObject App.Game.create
        player1: p1
        player2: p2
  ).observes("_round.matchesPerGame", "players.@each")




    



