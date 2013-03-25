roundViewTemplate = """

{{view App.RoundSetting roundBinding="round"}}

<div id="toolbar">
  <i id="qualifierCount" class="icon-retweet"></i>
  <i class="icon-chevron-up" {{action "toggleRound"}} id="toggleRound"></i>
</div>

{{#each game in round.items}}
  {{view App.GameView gameBinding="game"}}
{{/each}}
"""

App.RoundView = Em.View.extend
  template: Ember.Handlebars.compile roundViewTemplate
  classNames: ["round"]
  round: null

  onRoundItemsChanged: (->
    $("body").children(".tooltip").remove()
  ).observes("round.items.@each")

  didInsertElement: ->
    ###
    @$("#qualifierCount").popover
      html: true
      placement: "left"
      title: "Qualifikanten"
      content: =>
        @$("#qualifierPopover").html()
    ###
    @$("#qualifierCount").click =>
        App.RoundDetailView.create round: @round
    @$("#toggleRound").tooltip
        title: "Ein-/ Ausblenden"

  toggleRound: ->
    if @$("#toggleRound").attr("class") == "icon-chevron-down"
      @$(".roundItem").show "medium"
      @$().css "min-height", "130px"
      @$("#toggleRound").attr "class", "icon-chevron-up"

    else
      @$(".roundItem").hide "medium"
      @$("#settings .close").click()
      @$().css "min-height", "0px"
      @$("#toggleRound").attr "class", "icon-chevron-down"
      
    qualifierCount: (->
      @get("round").get("qualifiers").get("length")
    ).property("round.qualifiers")
