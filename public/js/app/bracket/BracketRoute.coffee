App.BracketIndexRoute = Ember.Route.extend
  controllerName: 'bracket'
  setupController: (controller) ->
    App.set 'editable', false

App.BracketEditRoute = Ember.Route.extend
  controllerName: 'bracket'
  setupController: (controller) ->
    App.set 'editable', true
