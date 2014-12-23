App.ParticipantsRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set "initialTab", "login"
