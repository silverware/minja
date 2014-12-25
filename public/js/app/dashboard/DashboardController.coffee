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

