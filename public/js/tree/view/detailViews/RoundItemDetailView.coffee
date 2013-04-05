App.RoundItemDetailView = App.GamesDetailView.extend
  roundItem: null
  
  navigateToRight: ->
    @navigate 1

  navigateToLeft: ->
    @navigate -1

  navigate: (offset) ->
    length = @roundItem._round.items.get "length"
    index = @roundItem._round.items.indexOf @roundItem
    index += offset
    console.debug length
    if index < 0 then index = length - 1
    if index >= length then index = 0
    console.debug index
    newRoundItem = @roundItem._round.items.objectAt index

    @$('.detailContent').fadeOut 'medium', =>
      @set "roundItem", newRoundItem
      @$('.detailContent').fadeIn 'medium'

  filteredGames: (->
    @get("roundItem.matchDays").map (matchDay) =>
      Em.Object.create
        games: App.utils.filterGames @get("gameFilter"), matchDay.games
        matchDay: matchDay.matchDay
  ).property("gameFilter", "roundItem.games.@each")
