App.SettingsRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set "initialTab", "login"