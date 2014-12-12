App.templates.tournament = """
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
          <button class="btn btn-inverse" {{action "edit" target="view"}} ><i class="fa fa-cog"></i>{{App.i18n.settings}}</button>
          <button type="submit" class="btn btn-inverse">{{App.i18n.save}}</button>
          <i class="fa fa-spinner fa-spin ajaxLoader"></i>
          <span class="successIcon"><i class="fa fa-check"></i> {{App.i18n.saved}}</span>
        </span>
      </form>
    </div>
  {{else}}
    {{#if App.isOwner}}
      <div class="saveActions box">
        <a href="bracket/edit">
          <button  style="margin: 1px 20px" class="btn btn-inverse"><i class="fa fa-edit"></i>{{App.i18n.edit}}</button>
        </a>
      </div>
    {{/if}}
  {{/if}}


  {{#if App.editable}}
    <div class="tournamentActions">
    <div class="roundSetting box">
      <span  id="tournamentAddRemoveActions" class="roundName"><i class="icon-plus"></i></span>
      <div class="actions">
        <button class="btn btn-inverse addKoRound" {{action "addKoRound" target="App.Tournament"}}><i class="fa fa-plus"></i>{{App.i18n.koRound}}</button>
        <button class="btn btn-inverse addGroupStage" {{action "addGroupRound" target="App.Tournament"}}><i class="fa fa-plus"></i>{{App.i18n.groupStage}}</button>
        <button class="btn btn-inverse deletePrevRound" {{action "removeLastRound" target="view"}}><i class="fa fa-trash-o"></i>{{App.i18n.previousRound}}</button>
      </div>
    </div>
    </div>
  {{/if}}

  <div style="clear: both"></div>
"""

App.TournamentView = Em.View.extend
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
    App.TournamentSettings.create
      tournament: App.Tournament

  removeLastRound: ->
    App.Popup.showQuestion
      title: App.i18n.deletePreviousRound
      bodyContent: App.i18n.deletePreviousRoundInfo
      onConfirm: =>
        App.Tournament.removeLastRound()
