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


App.init = ({isOwner, editable, i18n, sport, colors, tournament, messages}) ->
  App.set 'tournament', App.Tournament.create
    identifier: tournament.identifier
    publicName: tournament.publicName
    isOwner: isOwner
    messages: []
    bracket: App.Bracket.create()
    participants: App.Participants.create()
    info: App.Info.create(tournament.info)
    settings: Ember.Object.create(tournament.settings)

  App.set 'editable', false
  App.set 'i18n', i18n
  App.set 'sport', sport

  # initially fill with sport values
  if not _.isEmpty App.sport
    App.tournament.bracket.set "winPoints", App.sport.pointsPerWin
    App.tournament.bracket.set "drawPoints", App.sport.pointsPerDraw
    App.tournament.bracket.set "qualifierModus", App.sport.qualifierModus


  # Initialize Players
  if tournament?.members
    App.tournament.participants.initPlayers tournament.members

  # Build Bracket
  if tournament?.tree
    App.PersistanceManager.buildBracket tournament.tree

  # build messages
  if messages.length > 0
    for message in messages
      App.tournament.messages.pushObject App.Message.create message.value



$.fn.createTree = ->
  # Schließe Runden Settings
  setTimeout (->
    $("#settings .close").click()
    $("#tournamentAddRemoveActions").click()), 50

  view.appendTo @
  App.Observer.snapshot()

