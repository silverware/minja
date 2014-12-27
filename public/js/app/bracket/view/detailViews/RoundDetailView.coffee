App.RoundDetailView = App.GamesDetailView.extend
  round: null
  table: false

  didInsertElement: ->
    @_super()
    @$('.roundItemTitle').append """#{@round.name}"""

  prefillAttributes: ->
    App.GameAttributePrefillPopup.open @get("round.games")

App.RoundDetailController = Ember.Controller.extend
  round: null
  gameFilter: ""
  gamePlayedFilter: undefined

  init: ->
    @_super()
    @set 'filterOptions', [
      {id: undefined, label: App.i18n.bracket.all}
      {id: true, label: App.i18n.bracket.played}
      {id: false, label: App.i18n.bracket.open}
    ]

  gamesCount: (->
    @get('filteredGames').reduce (count, matchDay) ->
      count += matchDay.games.length
    , 0
  ).property("filteredGames")

  filteredGames: (->
    @get("round.matchDays").map (matchDay) =>
      Em.Object.create
        games: App.utils.filterGames {search: @get("gameFilter"), played: @get("gamesPlayedFilter")}, matchDay.games
        matchDay: matchDay.matchDay
  ).property("gameFilter", "gamesPlayedFilter", "round.games.@each")
