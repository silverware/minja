window.App = Em.Application.create
  LOG_TRANSITIONS: true,
  rootElement: '#appRoot'
  # LOG_TRANSITIONS_INTERNAL: true
  tournament: null

  openDetailViews: []
  i18n: {}
  templates: {}
  persist: ->
    App.PersistanceManager.persist()
  transitionTo: (route) ->
    App.Router.router.transitionTo route


App.init = ({isOwner, editable, i18n, sport, colors, tournament}) ->
  console.debug tournament
  App.set 'tournament', App.Tournament.create
    identifier: tournament.identifier
    publicName: tournament.publicName
  App.set 'tournament.bracket', App.Bracket.create()
  App.set 'tournament.participants', App.Participants.create()
  App.tournament.set "info", App.Info.create(tournament.info)
  App.tournament.set "settings", Ember.Object.create(tournament.settings)

  App.editable = false
  App.tournament.isOwner = isOwner
  App.i18n = i18n
  App.sport = sport

  # initially fill with sport values
  if App.sport
    App.tournament.bracket.set "winPoints", App.sport.pointsPerWin
    App.tournament.bracket.set "drawPoints", App.sport.pointsPerDraw
    App.tournament.bracket.set "qualifierModus", App.sport.qualifierModus


  # Initialize Players
  if tournament?.members
    App.tournament.participants.initPlayers tournament.members

  # Build Bracket
  if tournament?.tree
    App.PersistanceManager.buildBracket tournament.tree



$.fn.createTree = ->
  # Schließe Runden Settings
  setTimeout (->
    $("#settings .close").click()
    $("#tournamentAddRemoveActions").click()), 50

  view.appendTo @
  App.Observer.snapshot()

