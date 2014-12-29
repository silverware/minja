App.ParticipantsIndexRoute = Ember.Route.extend
  controllerName: 'participants'
  beforeModel: ->
    if App.tournament.participants.get('isEmpty') and App.tournament.get('isOwner')
      @transitionTo 'participants.edit'
  renderTemplate: ->
    @render 'participants'
  setupController: (controller) ->
    controller.set 'sortedPlayers', App.tournament.participants.sortedPlayers()
    App.set "editable", false

App.ParticipantsEditRoute = Ember.Route.extend
  controllerName: 'participants'
  renderTemplate: ->
    @render 'participants'
  setupController: (controller) ->
    controller.set 'sortedPlayers', App.tournament.participants.sortedPlayers()
    App.set "editable", true
  actions:
    willTransition: (transition) ->
      if App.Observer.hasChanges() and not confirm(App.i18n.bracket.unsavedChanges)
        console.debug 'abooooort'
        transition.abort()
        return
      else
        return true
  afterModel: (model) ->
    App.Observer.snapshot()

