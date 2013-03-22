tournamentViewTemplate = """
<form class="form-horizontal">
  <div class="control-group">
    <label class="control-label" for="pointsPerWin">Punkte/Sieg</label>
    <div class="controls">
      {{view App.NumberField id="pointsPerWin" valueBinding="tournament.winPoints"}}
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="pointsPerDraw">Punkte/Unentschieden</label>
    <div class="controls">
      {{view App.NumberField id="pointsPerDraw" valueBinding="tournament.drawPoints"}}
    </div>
  </div>
</form>
"""
App.TournamentPopup = Em.View.create(
  template: Ember.Handlebars.compile tournamentViewTemplate
  classNames: ["hide"]
  tournamentBinding: "App.Tournament"

  show: ->
    @$().show()
    Popup.show
      title: "Turnierbaum-Einstellungen"
      bodyContent: @$()[0]

).appendTo("body")