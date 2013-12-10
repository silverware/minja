App.BracketLineDrawer =
  ctx: null

  init: ->
    c = document.getElementById "bracketLines"
    @ctx = c.getContext "2d"
    #@update()

  update: ->
    App.Tournament.forEach (round) =>
      prev = round._previousRound
      if not prev then return
      if prev.isGroupRound or round.isGroupRound then return

      for gameCurrent in round.items
        playersCurrent = gameCurrent.get "players"
        for gamePrev in prev.items
          if _.intersection(playersCurrent, gamePrev.get("qualifiers")).length > 0
            @draw gameCurrent, gamePrev


  draw: (from, to) ->
    console.debug from, to
    console.debug from.get("_id")
    $("#gamesTable").forEach (n) ->
      console.debug n
    @ctx.beginPath()
    @ctx.moveTo 20,20
    @ctx.lineTo 20,100
    @ctx.lineTo 70,100
    @ctx.stroke()

  updateSize: ->


