App.BracketController = Ember.Controller.extend
  actions:
    addKoRound: ->
      App.tournament.bracket.addKoRound()
    addGroupRound: ->
      App.tournament.bracket.addGroupRound()
    openSettings: ->
      @send 'openDetailView', 'tournamentSettings'
    openRoundDetailView: (round) ->
      @send 'openDetailView', 'roundDetail',
        round: round
    openGameDetailView: (game) ->
      @send 'openDetailView', 'roundItemDetail',
        roundItem: game
        renderTable: false
    openGroupDetailView: (group) ->
      @send 'openDetailView', 'roundItemDetail',
        roundItem: group
        renderTable: true

    removeLastRound: ->
      App.Popup.showQuestion
        title: App.i18n.bracket.deletePreviousRound
        bodyContent: App.i18n.bracket.deletePreviousRoundInfo
        onConfirm: =>
          App.tournament.bracket.removeLastRound()

