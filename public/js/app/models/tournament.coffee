App.Tournament = Em.Object.extend
  isOwner: false
  publicName: ''
  identifier: ''
  info: null
  settings: null
  bracket: null
  participants: null

Ember.Controller.reopen
  i18n: (->
    return App.i18n
  ).property()
  participants: (->
    return App.tournament.participants
  ).property('App.tournament.participants')
  bracket: (->
    return App.tournament.bracket
  ).property()
  tournament: (->
    return App.tournament
  ).property()
  info: (->
    return App.tournament.info
  ).property()
  
