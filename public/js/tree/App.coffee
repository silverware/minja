window.App = Em.Application.create
  openDetailViews: []
  i18n: {}
  templates: {}
  persist: ->
    App.PersistanceManager.persist App.Tournament

App.init = (settings) ->
  App.editable = settings.editable or false
  App.isOwner = settings.isOwner or false
  App.i18n = settings.i18n
  App.sport = settings.sport
  App.colors = settings.colors

  # initially fill with sport values
  if App.sport
    App.Tournament.set "winPoints", App.sport.pointsPerWin
    App.Tournament.set "drawPoints", App.sport.pointsPerDraw
    App.Tournament.set "qualifierModus", App.sport.qualifierModus

  # Initialize Players
  if settings.members
    App.PlayerPool.initPlayers settings.members.members
    App.PlayerPool.initAttributes settings.members.membersAttributes

  # Build Bracket
  if settings.data
    App.PersistanceManager.build settings.data


$.fn.createTree = ->
  view = App.TournamentView.create()

  # Schließe Runden Settings
  setTimeout (->
    $("#settings .close").click()
    $("#tournamentAddRemoveActions").click()), 50

  view.appendTo @
  App.Observer.snapshot()

