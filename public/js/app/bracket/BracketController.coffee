App.BracketController = Ember.Controller.extend
  actions:
    addKoRound: ->
      App.tournament.bracket.addKoRound()
    addGroupRound: ->
      App.tournament.bracket.addGroupRound()
    removeLastRound: ->
      App.Popup.showQuestion
        title: App.i18n.bracket.deletePreviousRound
        bodyContent: App.i18n.bracket.deletePreviousRoundInfo
      onConfirm: =>
        App.tournament.bracket.removeLastRound()
