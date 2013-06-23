App.RoundDetailView = App.GamesDetailView.extend
  round: null
  table: false

  didInsertElement: ->
    @_super()
    @$('.roundItemTitle').append """#{@round.name}"""

  filteredGames: (->
    @get("round.matchDays").map (matchDay) =>
      Em.Object.create
        games: App.utils.filterGames @get("gameFilter"), matchDay.games
        matchDay: matchDay.matchDay
  ).property("gameFilter", "round.games.@each")

  prefillAttributes: ->
    App.GameAttributePrefillPopup.open @get("round.games")
