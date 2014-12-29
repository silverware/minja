App.ChatController = Ember.Controller.extend
  actions:
    showStopDate: ->
      App.tournament.set 'info.stopDate', App.tournament.info.startDate
    removeMessage: (message) ->
      $.post @get('messageRemoveUrl'), {id: message._id, rev: message._rev}
      App.tournament.messages.removeObject message
  
  messageCreateUrl: (->
    '/' + App.tournament.identifier + '/messages/create'
  ).property()
  messageRemoveUrl: (->
    '/' + App.tournament.identifier + '/messages/remove'
  ).property()

  sortedMessages: (->
    App.tournament.messages.concat().sort (m1, m2) ->
      return m1.created_at < m2.created_at
  ).property('App.tournament.messages.@each.created_at')

