App.RoundItemDetailView = App.GamesDetailView.extend()

App.RoundItemDetailController = App.GamesDetailController.extend
  roundItem: null
  
  actions:
    navigateToRight: ->
      @navigate 1

    navigateToLeft: ->
      @navigate -1

  navigate: (offset) ->
    length = @roundItem._round.items.get "length"
    index = @roundItem._round.items.indexOf @roundItem
    index += offset
    if index < 0 then index = length - 1
    if index >= length then index = 0
    newRoundItem = @roundItem._round.items.objectAt index

    # @$('.detailContent').fadeOut 'medium', =>
    #   @$('.detailContent').fadeIn 'medium'
    @set "roundItem", newRoundItem

  prefillAttributes: ->
    App.GameAttributePrefillPopup.open @get("roundItem.games")

  filteredGames: (->
    @get("roundItem.matchDays").map (matchDay) =>
      Em.Object.create
        games: App.utils.filterGames {search: @get("gameFilter"), played: @get("gamesPlayedFilter")}, matchDay.games
        matchDay: matchDay.matchDay
  ).property("gameFilter", "gamesPlayedFilter", "roundItem.games.@each")
