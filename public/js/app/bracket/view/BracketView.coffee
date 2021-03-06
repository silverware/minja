App.templates.bracket = """
  <div class="container" id="margin-container" style="height: 30px"></div>
  <div id="treeWrapper" class="noPrint">
  <div class="tournament">
  {{#each round in bracket}}
    {{#if round.isGroupRound}}
      {{view 'groupRound' round=round}}
    {{/if}}
    {{#if round.isKoRound}}
      {{view 'round' round=round}}
    {{/if}}
  {{/each}}

  <form id="bracket-form" action="#" method="post">
  {{#if editable}}
    <div class="saveActions box">
        <span>
          <button class="btn btn-inverse" {{action 'openSettings'}} ><i class="fa fa-cog"></i>{{i18n.bracket.settings}}</button>
          <button type="submit" class="btn btn-inverse">{{i18n.save}}</button>
          <i class="fa fa-spinner fa-spin ajaxLoader"></i>
          <span class="successIcon"><i class="fa fa-check"></i> {{i18n.saved}}</span>
        </span>
    </div>
  {{else}}
    {{#if tournament.isOwner}}
      <div class="saveActions box">
        {{#link-to 'bracket.edit'}}
          <button  style="margin: 1px 20px" class="btn btn-inverse"><i class="fa fa-edit"></i>{{i18n.edit}}</button>
        {{/link-to}}
      </div>
    {{/if}}
  {{/if}}
  </form>


  {{#if editable}}
    <div class="tournamentActions">
    <div class="roundSetting box">
      <span id="tournamentAddRemoveActions" class="roundName"><i class="icon-plus"></i></span>
      <div class="actions">
        <button class="btn btn-inverse addKoRound" {{action "addKoRound"}}><i class="fa fa-plus"></i>{{i18n.bracket.koRound}}</button>
        <button class="btn btn-inverse addGroupStage" {{action "addGroupRound"}}><i class="fa fa-plus"></i>{{i18n.bracket.groupStage}}</button>
        {{#if bracket.hasRounds}}
        <button class="btn btn-inverse deletePrevRound" {{action "removeLastRound"}}><i class="fa fa-trash-o"></i>{{i18n.bracket.previousRound}}</button>
        {{/if}}
      </div>
    </div>
    </div>
  {{/if}}

  <div style="clear: both"></div>
  </div>
  </div>
  <canvas id="bracket-lines" class="hidden-xs hidden-sm"></canvas>
"""

App.BracketView = Em.View.extend
  classNameBinding: ['controller.hide:hide']
  template: Ember.Handlebars.compile App.templates.bracket

  actions:
    save: ->

  didInsertElement: ->
    App.BracketLineDrawer.init()

    new Save
      form: @$ "#bracket-form"
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
    #
    # Schließe Runden Settings
    # setTimeout (->
    #   $("#settings .close").click()
    #   $("#tournamentAddRemoveActions").click()), 50

    App.Observer.snapshot()



