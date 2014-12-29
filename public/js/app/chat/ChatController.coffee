App.ChatController = Ember.Controller.extend
  actions:
    showStopDate: ->
      App.tournament.set 'info.stopDate', App.tournament.info.startDate
  
  chatUrl: (->
    '/' + App.tournament.identifier + '/chat/edit'
  ).property()

