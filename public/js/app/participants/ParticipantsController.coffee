App.ParticipantsController = Ember.Controller.extend
  actions:
    openPlayerView: (player) ->
      @send 'openDetailView', 'playerDetail',
        player: player
        editable: false
  participantsUrl: (->
    '/' + App.tournament.identifier + '/participants/edit'
  ).property()

  updateList: (->
    @set 'sortedPlayers', App.tournament.participants.sortedPlayers()
  ).observes('participants.players.@each')

