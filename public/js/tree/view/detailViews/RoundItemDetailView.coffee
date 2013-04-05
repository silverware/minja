App.BreadcrumbView = Em.View.extend
    roundItem: null
    template: Ember.Handlebars.compile """
      <div class="roundItemTitle">

        <div class="roundItemTitleLabel">
          <span class="carousel-control left" title="previous" {{action "navigateToLeft" target="parentView"}}>
            <i class="icon-arrow-left"></i>
          </span>
          {{roundItem.name}}
          <span class="carousel-control right" title="next" {{action "navigateToRight" target="parentView"}}>
            <i class="icon-arrow-right"></i>
          </span>

        </div>
      </div>
    """

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
      @breadcrumbView.set "roundItem", newRoundItem
      @$('.detailContent').fadeIn 'medium'

  didInsertElement: ->
    @_super()
    @breadcrumbView = App.BreadcrumbView.create
        roundItem: @roundItem
        parentView: @
    @breadcrumbView.appendTo @$()

  filteredGames: (->
    @get("roundItem.matchDays").map (matchDay) =>
      Em.Object.create
        games: App.utils.filterGames @get("gameFilter"), matchDay.games
        matchDay: matchDay.matchDay
  ).property("gameFilter", "roundItem.games.@each")
