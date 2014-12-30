App.SettingsController = Ember.Controller.extend
  colorsUrl: (->
    '/' + App.tournament.identifier + '/settings/colors'
  ).property()

  publicNameUrl: (->
    '/' + App.tournament.identifier + '/savePublicName'
  ).property()
