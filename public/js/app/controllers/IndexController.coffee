Chat.IndexController = Ember.ArrayController.extend
  actions:
    join: (chanName) ->
      #todo

  createAnonChan: ->
    $.post "/ajax/chan/create", ({chanName}) ->
      Chat.join chanName
