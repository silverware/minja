App.InfoEditController = Ember.Controller.extend
  actions:
    showStopDate: ->
      App.tournament.set 'info.stopDate', App.tournament.info.startDate
    hideStopDate: ->
      App.tournament.set 'info.stopDate', null
      App.tournament.set 'info.stopTime', null
    openPreview: ->
      src = App.tournament.get('info.description')
      compiled = if src then marked src else ""
      App.Popup.show
        title: App.i18n.info.preview
        cancelble: false
        bodyContent: compiled

  hasStopDate: (->
    if App.tournament.get 'info.stopDate'
      return true
    return false
  ).property('App.tournament.info.stopDate')
  
  infoEditUrl: (->
    '/' + App.tournament.identifier + '/info/edit'
  ).property()

