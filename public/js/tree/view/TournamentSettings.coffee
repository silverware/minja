App.templates.tournamentPopup = """
    <div class="container-fluid">
    <div class="row-fluid">
    <div class="span6">
<form class="form-horizontal">
  <fieldset>
    <legend>Spieleinstellung</legend>

  <div class="control-group">
    <label class="control-label" for="pointsPerWin">Punkte/Sieg</label>
    <div class="controls">
      {{view App.NumberField id="pointsPerWin" valueBinding="App.Tournament.winPoints"}}
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="pointsPerDraw">Punkte/Unentschieden</label>
    <div class="controls">
      {{view App.NumberField id="pointsPerDraw" valueBinding="App.Tournament.drawPoints"}}
    </div>
  </div>
  </fieldset>
</form>
    </div>
    <div class="span6">
    <!--Body content-->


  <fieldset>
    <legend>Spiele-Attribute</legend>
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
        <td>{{view Ember.Select contentBinding="App.attributeTypes" 
          optionValuePath="content.type" optionLabelPath="content.label" valueBinding="gameAttribute.type"}}</td>
        <td><i class="icon-remove" rel="tooltip" title="Delete" {{action "remove" target="gameAttribute"}}></i>
        </td>
      </tr>
      {{/each}}
    </table>
  <span class='btn btn-link' {{action "addAttribute"}}>Add Attribute</span>
  </fieldset>
    </div>
    </div>
    </div>
"""
App.TournamentPopup = App.DetailView.extend
  template: Ember.Handlebars.compile App.templates.tournamentPopup

  addAttribute: ->
    App.Tournament.gameAttributes.pushObject App.GameAttribute.create()
