App.RoundDetailView = App.GamesDetailView.extend
  round: null
  table: false

  didInsertElement: ->
    @_super()

  filteredGames: (->
    @get("round.items").reduce (filtered, roundItem) =>
      filteredGames = App.utils.filterGames @get("gameFilter.fastSearch"), roundItem.get("games").content
      for game in filteredGames
        game._roundItem = roundItem
      filtered.concat filteredGames
    , []
  ).property("gameFilter", "round.items.@each.games.@each")
