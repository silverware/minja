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
              {{#each attribute in App.Tournament.gameAttributes}}
                <th>{{attribute.name}}alter</th>
              {{/each}}
              <th>Ergebnis</th>
            </tr>
          </thead>
          {{#each game in filteredGames}}
            <tr>
              <td>{{game._roundItem.name}}</td>
              <td>{{game.player1.name}}</td>
              <td>{{game.player2.name}}</td>
              {{#each attribute in App.Tournament.gameAttributes}}
                {{view App.GameAttributeValueView attributeBinding="attribute" gameBinding="game"}}
              {{/each}}
              <td>
              {{#if App.editable}}
                  {{view App.NumberField editableBinding="App.editable" valueBinding="game.result1"}}
                  :
                  {{view App.NumberField editableBinding="App.editable" valueBinding="game.result2"}}
              {{else}}
                {{game.result1}} : {{game.result2}}
              {{/if}}
              </td>
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
    #@$().mCustomScrollbar()

  init: ->
    @_super()
    @set "gameFilter",
      fastSearch: null
      attributes: []


