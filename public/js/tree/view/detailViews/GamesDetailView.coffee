gamesDetailViewTemplate = """
<div class="container-fluid">
  <div class="row-fluid">
    <div class="span2">
      {{view App.FilterView gameFilterBinding="view.gameFilter"}}
    </div>
    <div class="span10">
      <fieldset>
        <legend>Spielplan</legend>
        <table class="table table-striped">
          <thead>
            <tr>
              <th></th>
              <th>Heim</th>
              <th>Auswärts</th>
              <th>Ergebnis</th>
            </tr>
          </thead>
          {{#each game in filteredGames}}
            <tr>
              <td>{{game.roundItem.name}}</td>
              <td>{{game.player1.name}}</td>
              <td>{{game.player2.name}}</td>
              <td>{{game.result1}} : {{game.result2}}</td>
            </tr>
          {{/each}}
        </table>
      </fieldset>
    </div>
  </div>
</div>

"""

App.GamesDetailView = App.DetailView.extend
  template: Ember.Handlebars.compile gamesDetailViewTemplate
  gameFilter: null

  didInsertElement: ->
    @_super()

  init: ->
    @_super()
    @set "gameFilter",
      fastSearch: null
      attributes: []
