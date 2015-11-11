App.DashboardController = Ember.Controller.extend
  initialTab: ""

  actions:
    login: ->
      #Log the user in, then reattempt previous transition if it exists.
      previousTransition = @get 'previousTransition'
      if previousTransition
        @set 'previousTransition', null
        if typeof previousTransition is 'string'
          @transitionTo previousTransition
        else
          previousTransition.retry()
      else
        #Default back to homepage
        @transitionToRoute 'index'

  participantCount: (->
    App.tournament.participants.players.length
  ).property('App.tournament.participants.players')

  subsetParticipants: (->
    App.tournament.participants.players[0..9]
  ).property('App.tournament.participants.players')

  participantListIsNotCompleted: (->
    @get('subsetParticipants').length isnt @get('participantCount')
  ).property('App.tournament.participants.players')

  sortedMessages: (->
    list = App.tournament.messages.concat().sort (m1, m2) ->
      return m1.created_at < m2.created_at
    _.first list, 3
  ).property('App.tournament.messages.@each.created_at')

