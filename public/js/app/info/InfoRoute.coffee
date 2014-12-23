App.InfoRoute = Ember.Route.extend
  model: ->
    $.get '/ajax/chans'

  renderTemplate: ->
    @_super()
    @render 'chanUsers',
      outlet: 'sidebar'

  setupController: (controller, chan) ->
    @_super controller, chan
    controller.set "title", chan.name
