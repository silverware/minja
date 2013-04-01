App.RoundItemDetailView = App.GamesDetailView.extend
  roundItem: null
  table: true

  BreadcrumbView: Em.View.extend
    roundItem: null
    template: Ember.Handlebars.compile """
      <div class="roundItemTitle">{{roundItem._round.name}}<span class="seperator">|</span>{{roundItem.name}}
        <!--<br />
        {{#each roundItem._round.items}}
          {{name}} <span class="seperator">|</span>
        {{/each}}-->
      </div>
    """

  didInsertElement: ->
    @_super()
    view = @BreadcrumbView.create
        roundItem: @roundItem
      view.appendTo @$()
    #@$().append """<div class="roundItemTitle">#{@roundItem._round.name} #{@roundItem.name}</div>"""

  filteredGames: (->
    console.debug "sdf"
    @get("roundItem.matchDays").map (matchDay) =>
      Em.Object.create
        games: App.utils.filterGames @get("gameFilter"), matchDay.games
        matchDay: matchDay.matchDay
  ).property("gameFilter", "roundItem.games.@each")
