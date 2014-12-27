App.RoundDetailView = App.GamesDetailView.extend
  round: null
  table: false

  didInsertElement: ->
    @_super()
    @$('.roundItemTitle').append @get('controller.round.name')

  prefillAttributes: ->
    App.GameAttributePrefillPopup.open @get("round.games")

App.RoundDetailController = App.GamesDetailController.extend
  round: null

  gamesCount: (->
    @get('filteredGames').reduce (count, matchDay) ->
      count += matchDay.games.length
    , 0
  ).property("filteredGames")

  filteredGames: (->
    console.debug 'FILTER'
    @get("round.matchDays").map (matchDay) =>
      Em.Object.create
        games: App.utils.filterGames {search: @get("gameFilter"), played: @get("gamesPlayedFilter")}, matchDay.games
        matchDay: matchDay.matchDay
  ).property("gameFilter", "gamesPlayedFilter", "round.games.@each")
