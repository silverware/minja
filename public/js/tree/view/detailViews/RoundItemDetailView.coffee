App.RoundItemDetailView = App.DetailView.extend
  roundItem: null
  gameFilter: null

  didInsertElement: ->
    @_super()
    @$().append """<div class="roundItemTitle">#{@roundItem._round.name} #{@roundItem.name}</div>"""

  init: ->
    @_super()
    @set "gameFilter",
      fastSearch: null
      attributes: []

  filteredGames: (->
    App.utils.filterGames @get("gameFilter.fastSearch"), @get("roundItem.games")
  ).property("gameFilter", "roundItem.games.@each")
