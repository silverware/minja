App.templates.tournamentPopup = """
    <div class="container-fluid">
    <div class="row-fluid">
    <div class="span6">
<form class="form-horizontal">
  <fieldset>
    <legend>{{App.i18n.settings}}</legend>
  <h5>{{App.i18n.groupStage}}</h5>
  <div class="control-group">
    <label class="control-label" for="pointsPerWin">{{App.i18n.pointsPerWin}}</label>
    <div class="controls">
      {{view App.NumberField id="pointsPerWin" valueBinding="App.Tournament.winPoints"}}
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="pointsPerDraw">{{App.i18n.pointsPerDraw}}</label>
    <div class="controls">
      {{view App.NumberField id="pointsPerDraw" valueBinding="App.Tournament.drawPoints"}}

      <i rel="popover" ref="points-per-draw" class="hide icon-info-sign" data-title="{{unbound App.i18n.pointsPerDraw}}"></i>
      <div id="points-per-draw" class="hide">{{App.i18n.pointsPerDrawHelp}}</div>
    </div>
  </div>
  <h5>{{App.i18n.koRound}}</h5>
    <div class="control-group">
    <label class="control-label" for="qualifierModus">Modus</label>
    <div class="controls">
      {{view Ember.Select id="qualifierModus" contentBinding="view.qualifierModiOptions"
          optionValuePath="content.id" optionLabelPath="content.label" valueBinding="App.Tournament.qualifierModus"}}
    </div>
  </div>

  </fieldset>
</form>
    </div>
    <div class="span6">
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
        <td>{{view Em.TextField valueBinding="gameAttribute.name" classNames="l"}}</td>
        <td>{{view Ember.Select contentBinding="view.gameAttributeOptions"
          optionValuePath="content.type" optionLabelPath="content.label" valueBinding="gameAttribute.type"}}</td>
        <td><i class="icon-remove" rel="tooltip" title="{{unbound App.i18n.deleteGameAttribute}}" {{action "remove" target="gameAttribute"}}></i>
        </td>
      </tr>
      {{/each}}
    </table>
  <span class='btn btn-link' {{action "addAttribute" target="view"}}><i class="icon-plus-sign"></i>&nbsp;{{App.i18n.addAttribute}}</span>
  </fieldset>
    </div>



  </div>

  <div class="row-fluid">
    <div class="span6">
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
