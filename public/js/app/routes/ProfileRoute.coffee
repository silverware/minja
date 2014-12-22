Chat.ProfileRoute = Ember.Route.extend Chat.EnsureAuthentificationMixin,
  renderTemplate: ->
    @_super()
    @render 'profileNav',
      outlet: 'sidebar'



Chat.ProfileIndexRoute = Chat.ProfileRoute.extend
  model: ->
    $.get "/ajax/user/" + Chat.ticket.username

Chat.ProfilePasswordRoute = Chat.ProfileRoute.extend()


Chat.ProfilePhotoRoute = Chat.ProfileRoute.extend()



