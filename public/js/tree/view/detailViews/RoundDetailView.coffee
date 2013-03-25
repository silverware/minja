App.RoundDetailView = App.GamesDetailView.extend
  round: null

  didInsertElement: ->
    @_super()

  filteredGames: (->
    @get("round.items").reduce (filtered, roundItem) =>
      filteredGames = App.utils.filterGames @get("gameFilter.fastSearch"), roundItem.get("games").content
      for game in filteredGames
        game.roundItem = roundItem
      filtered.concat filteredGames
    , []
  ).property("gameFilter", "round.items.@each.games.@each")
