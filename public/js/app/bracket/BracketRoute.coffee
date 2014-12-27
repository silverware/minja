App.BracketIndexRoute = Ember.Route.extend
  controllerName: 'bracket'
  setupController: (controller) ->
    controller.set "editable", false
    App.editable = false

App.BracketEditRoute = Ember.Route.extend
  controllerName: 'bracket'
  setupController: (controller) ->
    controller.set "editable", true
    App.editable = true
