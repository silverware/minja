App.RoundDetailView = App.DetailView.extend
  round: null
  gameFilter: null

  didInsertElement: ->
    @_super()

  init: ->
    @_super()
    @set "gameFilter",
      fastSearch: null
      attributes: []

  filteredGames: (->
    @get("round.items").reduce (filtered, roundItem) ->
      filtered.concat App.utils.filterGames @get("gameFilter.fastSearch"), roundItem.get("games")
    , []
  ).property("gameFilter", "round.items.@each.games.@each")
