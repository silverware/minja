App.utils =

 subStringContained: (s, sub) ->
    contained = s.toLowerCase().indexOf(sub.toLowerCase()) isnt -1
    #console.debug s, sub, contained
    return contained

  filterGames: (searchString, games) ->
    if not searchString then return games
    s = searchString.split ' '
    console.debug s
    filtered = games.filter (game) =>
      contains = s.every (ss) =>
        if not ss then return true
        a = @subStringContained game.player2.name, ss
        b = @subStringContained game.player1.name, ss
        return a or b
   	  console.debug game.player1.name, game.player2.name, contains
      contains
