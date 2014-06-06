App.templates.roundSetting = """

<div id="qualifierPopover" class="hide">
  <ul>
    {{#each qualifier in round.qualifiers}}
      <li>{{qualifier.name}}<br /></li>
    {{/each}}
  </ul>
</div>



<div class="roundName">&nbsp;{{round.name}}</div>

<div id="settings">
<button type="button" class="close">×</button>
  <button style="float: right" class="btn btn-inverse" {{action "addItem" target="round"}}><i class="fa fa-plus-circle"></i>{{round._itemLabel}}</button>
  <button style="float: right" class="btn btn-inverse" {{action "shuffle" target="view"}}><i class="fa fa-random"></i>{{App.i18n.shuffle}}</button>
        <label>Name</label> {{view Em.TextField classNames="s" valueBinding="round.name"}}<br />
        <label class="control-label">{{App.i18n.games}}</label>
            {{view App.NumberField classNames="xxs" editableBinding="round.isEditable" valueBinding="round.matchesPerGame"}}
</div>
"""

App.RoundSetting = Em.View.extend
  template: Ember.Handlebars.compile App.templates.roundSetting
  classNames: ["roundSetting box"]
  round: null

  didInsertElement: ->
    @$(".close").click =>
      @$("#settings").hide("medium")

    if App.editable
      @$(".roundName").click =>
        if @$("#settings").is(":visible")
          @$("#settings").hide "medium"
        else
          @$("#settings").show "medium"

  shuffle: ->
    #someGamesCompleted = @get('round.games').some (game) -> game.get('isCompleted')
    # Warnung ausgeben, falls dadurch Ergebnisse verfallen
    if true
      App.Popup.showQuestion
        title: App.i18n.shufflePlayers
        bodyContent: App.i18n.shufflePlayersDescription
        onConfirm: =>
          @round.shuffle()
    else
      @round.shuffle()
