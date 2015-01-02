App.ColorThemes =
  defaultTheme:
    name: "Standard Theme"
    content: "rgba(72, 82, 97, 0.7)"
    contentText: "rgba(255,255,255,1)"
    background: "rgba(106, 123, 145, 1)"
    footer: "rgba(52, 62, 77, 0.95)"
    footerText: "rgba(255,255,255,1)"

  redTheme:
    name: "Red Theme"
    content: "rgba(255,255,255,0.85)"
    contentText: "rgba(69,69,69,1)"
    background: "rgba(214,214,214,1)"
    footer: "rgba(143,40,26,0.95)"
    footerText: "rgba(255,255,255,1)"

  blueTheme:
    name: "Blue Theme"
    content: "rgba(250,250,250,0.8)"
    contentText: "rgba(69,69,69,1)"
    background: "rgba(97,160,255,0.95)"
    footer: "rgba(52,124,232,0.95)"
    footerText: "rgba(255,255,255,1)"

  alphaTheme:
    name: "Alpha Theme"
    content: "rgba(54,54,54,0.23)"
    contentText: "rgba(255,255,255,1)"
    background: "rgba(61,61,61,1)"
    footer: "rgba(0,0,0,0.46)"
    footerText: "rgba(255,255,255,1)"

  greenTheme:
    name: "Green Theme"
    content: "rgba(255,255,255,0.54)"
    contentText: "rgba(69,69,69,1)"
    background: "rgba(209,209,209,1)"
    footer: "rgba(56,140,49,0.95)"
    footerText: "rgba(255,255,255,1)"

  # blackTheme:
  #   name: "Black Theme"
  #   content: "rgba(0, 0, 0, 0.7)"
  #   contentText: "rgba(255,255,255,1)"
  #   background: "rgba(106, 123, 145, 1)"
  #   footer: "rgba(52, 62, 77, 0.95)"
  #   footerText: "rgba(255,255,255,1)"

  greyTheme:
    name: "Grey Theme"
    content: "rgba(54,54,54,0.7)"
    contentText: "rgba(255,255,255,1)"
    background: "rgba(115,115,115,1)"
    footer: "rgba(59,59,59,0.95)"
    footerText: "rgba(255,255,255,1)"

App.ColorThemes.list = ->
  Object.getOwnPropertyNames(App.ColorThemes).filter((name) -> return name isnt 'list').map (name) ->
    App.ColorThemes[name]
