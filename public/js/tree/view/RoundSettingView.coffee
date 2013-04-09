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
  <form class="form-horizontal">
      <div class="control-group">
        <label class="control-label">Name</label>
        <div class="controls">
          {{view Em.TextField classNames="s" valueBinding="round.name"}}
        </div>
      </div>
      <div class="control-group">
        <label class="control-label">{{App.i18n.games}}</label>
        <div class="controls">
            {{view App.NumberField classNames="xxs" editableBinding="round.isEditable" valueBinding="round.matchesPerGame"}}
        </div> 
      </div>
  </form>
  <button class="btn btn-inverse" {{action "addItem" target="round"}}><i class="icon-plus-sign"></i>{{round._itemLabel}}</button>
  <button class="btn btn-inverse" {{action "shuffle" target="view"}}><i class="icon-random"></i>Shuffle</button>
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
      confirmAction = 
        label: "Yes"
        closePopup: true
        action: =>
          @round.shuffle()
      App.Popup.show
        title: "Shuffle Players"
        bodyContent: "If you shuffle the players, all games of this round will be reverted"
        actions: [confirmAction, {label: "No", notBlue: true, closePopup: true, action: ->}]
    else
      @round.shuffle()
