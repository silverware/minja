App.BracketLineDrawer =
  draw: ->
    c = document.getElementById "backgroundCanvas"
    ctx = c.getContext "2d"
    ctx.beginPath()
    ctx.moveTo 20,20
    ctx.lineTo 20,100
    ctx.lineTo 70,100
    ctx.stroke()
