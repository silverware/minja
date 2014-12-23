App.DashboardRoute = Ember.Route.extend
  
  setupController: (controller) ->
    controller.set "initialTab", "login"

