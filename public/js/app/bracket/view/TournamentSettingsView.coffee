App.templates.tournamentSettings = """

  <div class="roundItemTitle">
    <div class="roundItemTitleLabel">
        <span class="round-item-name">{{i18n.bracket.settings}}</span>
    </div>
  </div>

<!--
menu erreichbar über Gruppenübersicht, Spielplan
Return-Icon links oben
menu: 
- standings, games settings
- TimeCalculations
- Punkteberechnung

-->


    <div class="container">
    <div class="row" style="margin: 0; padding: 0">
    <div class="col-md-2">
      <ul id="settings-navigation" class="nav nav-list">
        <li class="nav-header">Navigation</li>
        <li class="active"><a href="#" data-target="#main-settings">{{i18n.bracket.pointsModus}}</a></li>
        <li><a href="#" data-target="#gameAttributes">{{i18n.bracket.gameAttributes}}</a></li>
        <li><a href="#" data-target="#scheduling">{{i18n.bracket.timeCalculation}}</a></li>
    </ul> 
      
    </div>
    <div class="col-md-10">
    <div class="tab-content">
    <div id="main-settings" class="tab-pane active">
<form class="form-horizontal" role="form">
  <fieldset>
    <legend>{{i18n.bracket.groupStage}}</legend>
  <div class="form-group">
    <label class="control-label col-sm-2" for="pointsPerWin">{{i18n.bracket.pointsPerWin}}</label>
    <div class="col-sm-10 col-md-1">
      {{view 'numberField' id="pointsPerWin" classNames="form-control" valueBinding="tournament.bracket.winPoints"}}
    </div>
  </div>
  <div class="form-group">
    <label class="control-label col-sm-2" for="pointsPerDraw">{{i18n.bracket.pointsPerDraw}}</label>
    <div class="col-sm-10 col-md-1">
      {{view 'numberField' id="pointsPerDraw" classNames="form-control" valueBinding="tournament.bracket.drawPoints"}}

      <i rel="popover" ref="points-per-draw" class="hide fa fa-info-circle" data-title="{{unbound i18n.bracket.pointsPerDraw}}"></i>
      <div id="points-per-draw" class="hide">{{i18n.bracket.pointsPerDrawHelp}}</div>
    </div>
  </div>
  </fieldset>
  <fieldset>
    <legend>{{i18n.bracket.koRound}}</legend>
    <div class="form-group">
    <label class="control-label col-sm-2" for="qualifierModus">Modus</label>
    <div class="col-sm-10 col-md-2">
      {{view Ember.Select id="qualifierModus" contentBinding="view.qualifierModiOptions" classNames="form-control" 
          optionValuePath="content.id" optionLabelPath="content.label" valueBinding="tournament.bracket.qualifierModus"}}
    </div>
  </div>
  </fieldset>

    </form>
    </div>
    <div id="gameAttributes" class="tab-pane">
  <fieldset>
    <legend>{{i18n.bracket.gameAttributes}}</legend>
    <table class="table table-striped">
      <thead>
      <tr>
        <th style="text-align: left">Name</th>
        <th style="text-align: left">Typ</th>
        <th></th>
      </tr>
      </thead>
      {{#each gameAttribute in bracket.gameAttributes}}
      <tr>
        <td><div class="col-md-4">{{input value=gameAttribute.name classNames="form-control"}}</div></td>
        <td><div class="col-md-6">{{view Ember.Select contentBinding="view.gameAttributeOptions" classNames="form-control"
          optionValuePath="content.type" optionLabelPath="content.label" valueBinding="gameAttribute.type"}}</div></td>
        <td>
          <button class="btn btn-inverse" rel="tooltip" title="{{unbound i18n.bracket.deleteGameAttribute}}" {{action "remove" target="gameAttribute"}} type="button">
            <i class="fa fa-times"></i>
          </button>
        </td>
      </tr>
      {{/each}}
    </table>
  <span class='btn btn-inverse' {{action "addAttribute" target="view"}}><i class="fa fa-plus"></i>&nbsp;{{i18n.bracket.addAttribute}}</span>
  </fieldset>
  </div>

    <div id="scheduling" class="tab-pane">
      <fieldset>
        <legend>{{i18n.bracket.timeCalculation}}</legend>
        <form class="form-horizontal">
          <div class="form-group">
            <label class="control-label col-sm-2" for="timePerGame">{{i18n.bracket.timePerGame}}</label>
            <div class="col-sm-10 col-md-1">
              {{view 'numberField' classNames="form-control" id="timePerGame" valueBinding="bracket.timePerGame"}}
            </div>
          </div>

          <div class="form-group">
            <label class="control-label col-sm-2" for="gamesParallel">{{i18n.bracket.gamesParallel}}</label>
            <div class="col-sm-10 col-md-1">
              {{view 'numberField' classNames="form-control" id="gamesParallel" valueBinding="bracket.gamesParallel"}}
            </div>
          </div>
        </form>
        <dl class="dl-horizontal">
          <dt>Rounds</dt>
          <dd>{{view.roundCount}}</dd>
          <dt>Total Games</dt>
          <dd>{{view.gamesCount}}</dd>
          <dt>Estimated total time</dt>
          <dd>{{view.timeCount}} min</dd>
        </dl>
      </fieldset>
    </div>
  </div>
    </div>
    </div>
    </div>

"""
App.TournamentSettingsView = App.DetailView.extend
  template: Ember.Handlebars.compile App.templates.tournamentSettings

  didInsertElement: ->
    @_super()
    @$("[rel=popover]").popover
        html: true
        trigger: "hover"
        content: ->
          $("##{$(@).attr('ref')}").html()
    @$('#settings-navigation a').click (event) ->
      event.preventDefault()
      console.debug @
      $(@).tab 'show'

  actions:
    addAttribute: ->
      App.tournament.bracket.gameAttributes.pushObject App.GameAttribute.create()

  roundCount: (->
    App.tournament.bracket.get 'length'
  ).property('App.tournament.bracket.@each')

  gamesCount: (->
    App.tournament.bracket.reduce (count, item) ->
      count += item.get('games.length')
    , 0
  ).property('App.tournament.bracket.@each')

  timeCount: (->
    minutes = @get('gamesCount') * App.tournament.bracket.timePerGame / App.tournament.bracket.gamesParallel
    minutes.toFixed()
    #moment('mm', minutes).format('h m')
  ).property('gamesCount', 'App.tournament.bracket.timePerGame', 'App.tournament.bracket.gamesParallel')

  gameAttributeOptions: (->
    [
      Em.Object.create {type: "checkbox", label: "Checkbox"}
      Em.Object.create {type: "textfield", label: App.i18n.bracket.textfield}
      Em.Object.create {type: "result", label: App.i18n.bracket.result}
      Em.Object.create {type: "number", label: App.i18n.bracket.number}
    ]
  ).property()

  qualifierModiOptions: (->
    [App.qualifierModi.BEST_OF, App.qualifierModi.AGGREGATE]
  ).property()

App.TournamentSettingsController = Ember.Controller.extend()
