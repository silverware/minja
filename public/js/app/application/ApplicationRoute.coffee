App.ApplicationRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set "initialTab", "login"
