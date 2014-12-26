App.SettingsController = Ember.Controller.extend
  initialTab: ""
  actions:
    submitColors: (form, a) ->
      console.debug form
      console.debug a

  colorsUrl: (->
    '/' + App.tournament.identifier + '/settings/colors'
  ).property()
