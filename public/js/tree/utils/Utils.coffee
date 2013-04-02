App.utils =

  subStringContained: (s, sub) ->
    if not s then return false
    s.toLowerCase().indexOf(sub.toLowerCase()) isnt -1

  filterGames: (searchString, games) ->
    if not searchString then return games
    s = searchString.split ' '
    filtered = games.filter (game) =>
      s.every (ss) =>
        if not ss then return true
        attributes = []
        p1 = @subStringContained game.player1.name, ss
        p2 = @subStringContained game.player2.name, ss
        for attribute in App.Tournament.gameAttributes when attribute.get("isTextfield")
          attributes.push attribute.id
        attrs = attributes.some (attr) => @subStringContained game[attr], ss
        p1 or p2 or attrs
