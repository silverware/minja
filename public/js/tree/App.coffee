window.App = Em.Application.create
  openDetailViews: []
  i18n: {}
  templates: {}
  persist: ->
    App.PersistanceManager.persist()

App.init = ({isOwner, editable, i18n, sport, colors, tournament}) ->
  App.editable = editable or false
  App.isOwner = isOwner or false
  App.i18n = i18n
  App.sport = sport
  App.colors = colors

  # initially fill with sport values
  if App.sport
    App.Tournament.set "winPoints", App.sport.pointsPerWin
    App.Tournament.set "drawPoints", App.sport.pointsPerDraw
    App.Tournament.set "qualifierModus", App.sport.qualifierModus

  # Initialize Players
  if tournament.members
    App.PlayerPool.initPlayers tournament.members

  # Build Bracket
  if tournament.tree
    App.PersistanceManager.build tournament.tree


$.fn.createTree = ->
  view = App.TournamentView.create()

  # Schließe Runden Settings
  setTimeout (->
    $("#settings .close").click()
    $("#tournamentAddRemoveActions").click()), 50

  view.appendTo @
  App.Observer.snapshot()

