App.BracketIndexRoute = Ember.Route.extend
  controllerName: 'bracket'
  setupController: (controller) ->
    App.set 'editable', false

App.BracketEditRoute = Ember.Route.extend
  controllerName: 'bracket'
  setupController: (controller) ->
    App.set 'editable', true
  afterModel: (model) ->
    App.Observer.snapshot()
  actions:
    willTransition: (transition) ->
      if App.Observer.hasChanges() and !confirm(App.i18n.bracket.unsavedChanges)
        transition.abort()
      else
        return true
