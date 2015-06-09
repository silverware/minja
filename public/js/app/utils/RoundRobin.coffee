###
  RoundRobin eine Klasse um in einer Liga Spieltage zu erzeugen.
  Der Algorithmus der Berechnung folgt in etwa dem, der auf dieser Seite beschrieben wird: http://www-i1.informatik.rwth-aachen.de/~algorithmus/algo36.php
###
App.RoundRobin =
  generateGames: (players) ->
    if !players then throw new TypeError "Parameter must be greater than zero"

    if players.length % 2 != 0
      games = @generate players.length + 1
    else
      games = @generate players.length

    # spielern den platzhaltern zuordnen
    result = []
    for game in games
      if players[game[0] - 1] and players[game[1] - 1]
        result.push [players[game[0] - 1], players[game[1] - 1]]
    result

  generate: (teamCount) ->
    # nur gerade Anzahl Teams erlaubt
    if ((teamCount % 2) != 0)
      return false

    if teamCount == 2
      return [[1,2]]

    # --- Spielpaarungen bestimmen ---------------------------------------
    n      = teamCount - 1
    spiele = []

    for i in [1..teamCount - 1]
      h = teamCount
      a = i
      # heimspiel? auswärtsspiel?
      if ((i % 2) != 0)
        temp = a
        a = h
        h = temp

       spiele.push [h, a]

       for k in [1..((teamCount / 2) - 1)]
          if ((i - k) < 0)
            a = n + (i-k)
          else
            a = (i-k) % n
            a = if (a == 0) then n else a # 0 -> n-1

          h = (i+k) % n
          h = if (h == 0) then n else h    # 0 -> n-1

          # heimspiel? auswärtsspiel?
          if ((k % 2) == 0)
             temp = a
             a    = h
             h    = temp

          spiele.push [h, a]
    spiele

