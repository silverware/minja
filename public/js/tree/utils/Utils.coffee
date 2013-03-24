App.utils =

 subStringContained: (s, sub) ->
    s.toLowerCase().indexOf(sub.toLowerCase()) isnt -1

  filterGames: (searchString, games) ->
    if not searchString then return games
    s = searchString.split ' '
    filtered = games.filter (game) =>
      s.every (ss) =>
        if not ss then return true
        p1 = @subStringContained game.player2.name, ss
        p2 = @subStringContained game.player1.name, ss
        return p1 or p2
