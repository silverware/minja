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
  {{#if round.isEditable}}
    <!--<button class="btn" {{action "randomPlayers" target="round"}}>random </button>-->
    <button class="btn btn-inverse roundAddButton" {{action "addItem" target="round"}}><i class="icon-plus-sign"></i>{{round._itemLabel}}</button>
  {{/if}}
</div>

"""

App.RoundSetting = Em.View.extend
  template: Ember.Handlebars.compile App.templates.roundSetting
  classNames: ["roundSetting box"]

  didInsertElement: ->
    @$(".close").click =>
      @$("#settings").hide("medium")

    if App.editable
      @$(".roundName").click =>
        if @$("#settings").is(":visible")
          @$("#settings").hide "medium"
        else
          @$("#settings").show "medium"

      
