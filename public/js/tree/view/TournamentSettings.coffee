App.templates.tournamentPopup = """


<!--
menu erreichbar über Gruppenübersicht, Spielplan
Return-Icon links oben
menu: 
- standings, games settings
- TimeCalculations
- Punkteberechnung

-->


    <div class="row" style="margin: 0; padding: 0">
    <div class="col-md-2">
      <ul id="settings-navigation" class="nav nav-list">
        <li class="nav-header">{{App.i18n.settings}}</li>
        <li class="active"><a href="#" data-target="#main-settings">{{App.i18n.pointsModus}}</a></li>
        <li><a href="#" data-target="#gameAttributes">{{App.i18n.gameAttributes}}</a></li>
        <li><a href="#" data-target="#scheduling">{{App.i18n.timeCalculation}}</a></li>
    </ul> 
      
    </div>
    <div class="col-md-10">
    <div class="tab-content">
    <div id="main-settings" class="tab-pane active">
<form class="form-horizontal" role="form">
  <fieldset>
    <legend>{{App.i18n.groupStage}}</legend>
  <div class="form-group">
    <label class="control-label col-sm-2" for="pointsPerWin">{{App.i18n.pointsPerWin}}</label>
    <div class="col-sm-10 col-mg-1">
      {{view App.NumberField id="pointsPerWin" classNames="form-control" valueBinding="App.Tournament.winPoints"}}
    </div>
  </div>
  <div class="form-group">
    <label class="control-label col-sm-2" for="pointsPerDraw">{{App.i18n.pointsPerDraw}}</label>
    <div class="col-sm-10 col-mg-1">
      {{view App.NumberField id="pointsPerDraw" classNames="form-control" valueBinding="App.Tournament.drawPoints"}}

      <i rel="popover" ref="points-per-draw" class="hide fa fa-info-circle" data-title="{{unbound App.i18n.pointsPerDraw}}"></i>
      <div id="points-per-draw" class="hide">{{App.i18n.pointsPerDrawHelp}}</div>
    </div>
  </div>
  </fieldset>
  <fieldset>
    <legend>{{App.i18n.koRound}}</legend>
    <div class="form-group">
    <label class="control-label col-sm-2" for="qualifierModus">Modus</label>
    <div class="col-sm-10 col-md-2">
      {{view Ember.Select id="qualifierModus" contentBinding="view.qualifierModiOptions" classNames="form-control" 
          optionValuePath="content.id" optionLabelPath="content.label" valueBinding="App.Tournament.qualifierModus"}}
    </div>
  </div>
  </fieldset>

    </form>
    </div>
    <div id="gameAttributes" class="tab-pane">
  <fieldset>
    <legend>{{App.i18n.gameAttributes}}</legend>
    <table class="table table-striped">
      <thead>
      <tr>
        <th>Name</th>
        <th>Typ</th>
        <th></th>
      </tr>
      </thead>
      {{#each gameAttribute in App.Tournament.gameAttributes}}
      <tr>
        <td>{{view Em.TextField valueBinding="gameAttribute.name" classNames="form-control"}}</td>
        <td>{{view Ember.Select contentBinding="view.gameAttributeOptions" classNames="form-control"
          optionValuePath="content.type" optionLabelPath="content.label" valueBinding="gameAttribute.type"}}</td>
        <td><i class="fa fa-times" rel="tooltip" title="{{unbound App.i18n.deleteGameAttribute}}" {{action "remove" target="gameAttribute"}}></i>
        </td>
      </tr>
      {{/each}}
    </table>
  <span class='btn btn-link' {{action "addAttribute" target="view"}}><i class="fa fa-plus-circle"></i>&nbsp;{{App.i18n.addAttribute}}</span>
  </fieldset>
  </div>

    <div id="scheduling" class="tab-pane">
      <fieldset>
        <legend>{{App.i18n.timeCalculation}}</legend>
        <form class="form-horizontal">
          <div class="control-group">
            <label class="control-label" for="timePerGame">{{App.i18n.timePerGame}}</label>
            <div class="controls">
              {{view App.NumberField classNames="xs" id="timePerGame" valueBinding="App.Tournament.timePerGame"}} min
            </div>
          </div>

          <div class="control-group">
            <label class="control-label" for="gamesParallel">{{App.i18n.gamesParallel}}</label>
            <div class="controls">
              {{view App.NumberField id="gamesParallel" valueBinding="App.Tournament.gamesParallel"}}
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

"""
App.TournamentSettings = App.DetailView.extend
  template: Ember.Handlebars.compile App.templates.tournamentPopup
  tournament: null

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


  addAttribute: ->
    App.Tournament.gameAttributes.pushObject App.GameAttribute.create()

  roundCount: (->
    @get 'tournament.length'
  ).property('tournament.@each')

  gamesCount: (->
    @get('tournament').reduce (count, item) ->
      count += item.get('games.length')
    , 0
  ).property('tournament.@each')

  timeCount: (->
    minutes = @get('gamesCount') * @get('tournament.timePerGame') / @get('tournament.gamesParallel')
    minutes.toFixed()
    #moment('mm', minutes).format('h m')
  ).property('gamesCount', 'tournament.timePerGame', 'tournament.gamesParallel')

  gameAttributeOptions: (->
    [
      Em.Object.create {type: "checkbox", label: "Checkbox"}
      Em.Object.create {type: "textfield", label: App.i18n.textfield}
      Em.Object.create {type: "result", label: App.i18n.result}
      Em.Object.create {type: "number", label: App.i18n.number}
    ]
  ).property()

  qualifierModiOptions: (->
    [App.qualifierModi.BEST_OF, App.qualifierModi.AGGREGATE]
  ).property()
