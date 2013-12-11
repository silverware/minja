App.BracketLineDrawer =
  ctx: null

  init: ->
    return
    c = document.getElementById "bracketLines"
    @ctx = c.getContext "2d"
    @update()

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
    posFrom = @getCenterPos $("." + from.get('itemId'))
    posTo = @getCenterPos $("." + to.get('itemId'))

    midY = posFrom.y + ((posTo.y - posFrom.y) / 2)

    @ctx.beginPath()
    @ctx.moveTo posFrom.x, posFrom.y
    @ctx.lineTo posFrom.x, midY
    @ctx.lineTo posTo.x, midY
    @ctx.lineTo posTo.x, posTo.y
    @ctx.stroke()

  getCenterPos: (element) ->
    pos =
      x: element.offset().left + element.width() / 2
      y: element.offset().top + element.height() / 2


  updateSize: ->


