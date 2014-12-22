Chat.IndexRoute = Ember.Route.extend
  model: ->
    $.get '/ajax/chans'


