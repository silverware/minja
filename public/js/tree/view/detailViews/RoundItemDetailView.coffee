App.RoundItemDetailView = App.GamesDetailView.extend
  roundItem: null

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

    filteredGames: (->
      App.utils.filterGames @get("gameFilter.fastSearch"), @get("roundItem.games")
    ).property("gameFilter", "roundItem.games.@each")

  didInsertElement: ->
    @_super()
    view = @BreadcrumbView.create
        roundItem: @roundItem
      view.appendTo @$()
    #@$().append """<div class="roundItemTitle">#{@roundItem._round.name} #{@roundItem.name}</div>"""

  filteredGames: (->
    App.utils.filterGames @get("gameFilter.fastSearch"), @get("roundItem.games")
  ).property("gameFilter", "roundItem.games.@each")
