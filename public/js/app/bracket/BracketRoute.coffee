App.BracketRoute = Ember.Route.extend

  setupController: (controller, videoChat) ->
    @_super controller, videoChat
    controller.set "title", "Video Chat"

  renderTemplate: ->
    @render 'bracket'
