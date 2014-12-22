Chat.ApplicationController = Ember.Controller.extend Chat.GeoLocationMixin,

  init: ->
    @_super()

  logout: ->
    Chat.logout()

  onAuthSuccess: (->
    if Chat.get "isAuthenticated"
      @getLocation (position) ->
        $.post "/ajax/user/geolocation", position: position, ticket: Chat.ticket
  ).observes("Chat.isAuthenticated")


