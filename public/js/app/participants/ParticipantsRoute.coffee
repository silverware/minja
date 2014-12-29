App.ParticipantsIndexRoute = Ember.Route.extend
  controllerName: 'participants'
  renderTemplate: ->
    @render 'participants'
  setupController: (controller) ->
    controller.set 'sortedPlayers', App.tournament.participants.sortedPlayers()
    App.set "editable", false
    console.debug 'b'

App.ParticipantsEditRoute = Ember.Route.extend
  controllerName: 'participants'
  renderTemplate: ->
    @render 'participants'
  setupController: (controller) ->
    controller.set 'sortedPlayers', App.tournament.participants.sortedPlayers()
    App.set "editable", true
    console.debug 'a'
  actions:
    willTransition: (transition) ->
      if App.Observer.hasChanges() and !confirm(App.i18n.bracket.unsavedChanges)
        transition.abort()
      else
        return true
  afterModel: (model) ->
    App.Observer.snapshot()

