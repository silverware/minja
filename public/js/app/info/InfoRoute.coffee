Chat.ChanRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  model: ({chan_name}) ->
    chan = Chat.getChanByName chan_name
    if chan
      chan.set "newMessages", 0
      return chan
    Chat.join chan_name

  renderTemplate: ->
    @_super()
    @render 'chanUsers',
      outlet: 'sidebar'

  setupController: (controller, chan) ->
    @_super controller, chan
    controller.set "title", chan.name



