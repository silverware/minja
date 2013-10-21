App.RoundView = Em.View.extend
  template: Ember.Handlebars.compile """
    {{view App.RoundSetting roundBinding="round"}}
    <div id="toolbar">
      <i id="openDetailView" class="icon-search"></i>
      <i class="icon-chevron-up" {{action "toggleRound" target="view"}} id="toggleRound"></i>
    </div>

    {{#each game in round.items}}
      {{view App.GameView gameBinding="game"}}
    {{/each}}
  """

  classNames: ["round"]
  classNameBindings: ["roundMargin"]
  round: null

  onRoundItemsChanged: (->
    $("body").children(".tooltip").remove()
  ).observes("round.items.@each")

  didInsertElement: ->
    #@$().addClass "round-#{@round.koRoundsBefore()}" if @round.isKoRound
    @$("#openDetailView").click =>
        App.RoundDetailView.create round: @round
    @$("#openDetailView").tooltip
      title: "#{App.i18n.schedule} #{App.i18n.detailView}"

  roundMargin: (->
    roundIndex = 0
    round = @round
    while round and round.koRoundsBefore() > 0
      prevRound = round._previousRound
      isValid = (round.items.length / prevRound.items.length) is 0.5
      if not isValid then break
      roundIndex++
      round = prevRound
    "round-#{roundIndex}"
  ).property("round.items.@each")

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

