App.templates.tournament = """
<div id="tournament">
  {{#each round in App.Tournament}}
    {{#if round.isGroupRound}}
      {{view App.GroupRoundView roundBinding="round"}}
    {{/if}}
    {{#if round.isKoRound}}
      {{view App.RoundView roundBinding="round"}}
    {{/if}}
  {{/each}}

  {{#if App.editable}}
    <div class="saveActions box">
      <form action="#" method="post" style="margin: 1px 20px">
        <span>
          <button class="btn btn-inverse" {{action "edit" target="view"}} ><i class="icon-cog"></i>{{App.i18n.settings}}</button>
          <button type="submit" class="btn btn-primary">{{App.i18n.save}}</button>
          <img class="ajaxLoader" src="/img/ajax-loader.gif" />
          <span class="successIcon" style="color: white"><i class="icon-ok"></i> gespeichert</span>
        </span>
      </form>
    </div>
  {{else}}
    {{#if App.isOwner}}
      <div class="saveActions box">
        <a href="tree/edit">
          <button  style="margin: 1px 20px" class="btn btn-inverse"><i class="icon-edit"></i>{{App.i18n.edit}}</button>
        </a>
      </div>
    {{/if}}
  {{/if}}


  {{#if App.editable}}
    <div class="tournamentActions">
    <div class="roundSetting box">
      <span  id="tournamentAddRemoveActions" class="roundName"><i class="icon-plus"></i></span>
      <div class="actions">
        <button class="btn btn-inverse" {{action "addKoRound" target="App.Tournament"}}><i class="icon-plus-sign"></i>{{App.i18n.koRound}}</button>
        <button class="btn btn-inverse" {{action "addGroupRound" target="App.Tournament"}}><i class="icon-plus-sign"></i>{{App.i18n.groupStage}}</button>
        <button class="btn btn-danger" {{action "removeLastRound" target="App.Tournament"}}><i class="icon-trash"></i>{{App.i18n.previousRound}}</button>
      </div>
    </div>
    </div>
  {{/if}}

  <div style="clear: both"></div>
</div>
"""

App.TournamentView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.tournament

  didInsertElement: ->
    new Save
      form: $ "form"
      data: App.persist

    if App.editable
      @$(".tournamentActions .roundName").click =>
        if @$(".tournamentActions .actions").is(":visible")
          @$(".tournamentActions .actions").hide "medium"
        else
          @$(".tournamentActions .actions").show "medium"

  edit: ->
    App.TournamentSettings.create()
