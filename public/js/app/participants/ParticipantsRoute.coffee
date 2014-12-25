App.ParticipantsRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set "editable", false

App.ParticipantsEditRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set "editable", true
