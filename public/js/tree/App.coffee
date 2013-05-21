window.App = Em.Application.create
  i18n: {}
  templates: {}

$.fn.createTree = (settings) ->
  view = App.TournamentView.create()
  App.editable = settings.editable or false
  App.isOwner = settings.isOwner or false
  App.i18n = settings.i18n
  App.sport = settings.sport

  # initially fill with sport values
  App.Tournament.set "winPoints", App.sport.pointsPerWin
  App.Tournament.set "drawPoints", App.sport.pointsPerDraw
  App.Tournament.set "qualifierModus", App.sport.qualifierModus

  # Baue Baum
  if settings.data
    App.PersistanceManager.build settings.data

    # Schließe Runden Settings
    setTimeout (-> 
      $("#settings .close").click()
      $("#tournamentAddRemoveActions").click()), 50

  view.appendTo @

  # Übernimmt die Teilnehmer aus der Teilnehmerliste
  if not settings.data and settings.initialMembers
    App.initialMembers = []
    for member in settings.initialMembers.members
      player = App.Player.create
        name: member.name
      App.initialMembers.pushObject player

  App.persist = ->
    App.PersistanceManager.persist App.Tournament
