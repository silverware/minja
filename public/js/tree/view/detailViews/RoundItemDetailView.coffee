App.RoundItemDetailView = App.GamesDetailView.extend
  roundItem: null

  didInsertElement: ->
    @_super()
    @$().append """<div class="roundItemTitle">#{@roundItem._round.name} #{@roundItem.name}</div>"""

  filteredGames: (->
    App.utils.filterGames @get("gameFilter.fastSearch"), @get("roundItem.games")
  ).property("gameFilter", "roundItem.games.@each")
