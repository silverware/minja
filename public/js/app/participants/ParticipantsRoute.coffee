App.ParticipantsIndexRoute = Ember.Route.extend
  controllerName: 'participants'
  setupController: (controller) ->
    controller.set "editable", false
    console.debug 'b'

App.ParticipantsEditRoute = Ember.Route.extend
  controllerName: 'participants'
  setupController: (controller) ->
    controller.set "editable", true
    console.debug 'a'
