App.templates.tournament = """
  {{#each round in bracket}}
    {{#if round.isGroupRound}}
      {{view 'groupRound' roundBinding="round"}}
    {{/if}}
    {{#if round.isKoRound}}
      {{view 'round' roundBinding="round"}}
    {{/if}}
  {{/each}}

  {{#if editable}}
    <div class="saveActions box">
      <form action="#" method="post" style="margin: 1px 20px">
        <span>
          <button class="btn btn-inverse" {{action "edit" target="view"}} ><i class="fa fa-cog"></i>{{i18n.settings}}</button>
          <button type="submit" class="btn btn-inverse">{{i18n.save}}</button>
          <i class="fa fa-spinner fa-spin ajaxLoader"></i>
          <span class="successIcon"><i class="fa fa-check"></i> {{i18n.saved}}</span>
        </span>
      </form>
    </div>
  {{else}}
    {{#if tournament.isOwner}}
      <div class="saveActions box">
        <a href="bracket/edit">
          <button  style="margin: 1px 20px" class="btn btn-inverse"><i class="fa fa-edit"></i>{{i18n.edit}}</button>
        </a>
      </div>
    {{/if}}
  {{/if}}


  {{#if editable}}
    <div class="tournamentActions">
    <div class="roundSetting box">
      <span  id="tournamentAddRemoveActions" class="roundName"><i class="icon-plus"></i></span>
      <div class="actions">
        <button class="btn btn-inverse addKoRound" {{action "addKoRound" target="bracket"}}><i class="fa fa-plus"></i>{{i18n.koRound}}</button>
        <button class="btn btn-inverse addGroupStage" {{action "addGroupRound" target="bracket"}}><i class="fa fa-plus"></i>{{i18n.groupStage}}</button>
        <button class="btn btn-inverse deletePrevRound" {{action "removeLastRound" target="view"}}><i class="fa fa-trash-o"></i>{{i18n.previousRound}}</button>
      </div>
    </div>
    </div>
  {{/if}}

  <div style="clear: both"></div>
"""

App.BracketView = Em.View.extend
  classNames: ["tournament"]
  template: Ember.Handlebars.compile App.templates.tournament

  didInsertElement: ->
    @$().hide()
    $(".loading-screen").fadeOut 'medium', =>
      @$().fadeIn 'slow', ->
        App.BracketLineDrawer.init()

    new Save
      form: $ "form"
      data: App.persist
      onSave: ->
        App.Observer.snapshot()

    @$(".deletePrevRound").tooltip
      title: App.i18n.deletePreviousRound
    @$(".addGroupStage").tooltip
      title: App.i18n.addGroupStage
    @$(".addKoRound").tooltip
      title: App.i18n.addKoRound

    if App.editable
      @$(".tournamentActions .roundName").click =>
        if @$(".tournamentActions .actions").is ":visible"
          @$(".tournamentActions .actions").hide "medium"
        else
          @$(".tournamentActions .actions").show "medium"

  edit: ->
    App.TournamentSettingsView.create()

  removeLastRound: ->
    App.Popup.showQuestion
      title: App.i18n.deletePreviousRound
      bodyContent: App.i18n.deletePreviousRoundInfo
      onConfirm: =>
        App.tournament.bracket.removeLastRound()
