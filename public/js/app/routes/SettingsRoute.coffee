App.SettingsRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set "initialTab", "login"

App.SignupRoute = Ember.Route.extend
  renderTemplate: ->
    @render 'login'

  setupController: ->
    @controllerFor('login').set "initialTab", "register"
