gamesDetailViewTemplate = """
      {{#if table}}
      <fieldset>
<legend>Tabelle</legend>

<table class="table table-striped" style="max-width: 800px; margin: 0 auto;">
  <thead>
    <tr>
      <th>Rang</th>
      <th>Name</th>
      <th>Spiele</th>
      <th>Tore</th>
      <th>Gegentore</th>
      <th>Differenz</th>
      <th>Punkte</th>
    </tr>
  </thead>
  <tbody>
    {{#each roundItem.table}}
      {{#if qualified}}
        <tr class="player qualified" >
      {{else}}
        <tr class="player">
      {{/if}}
      <td class="tableCell" style="text-align: center; vertical-align: middle">
        {{rank}}.
      </td>
      <td class="tableCell reallyNoPadding">
        {{view App.DynamicTextField valueBinding="player.name" editableBinding="player.editable"}}
      </td>
      <td class="tableCell">{{games}}</td>
      <td class="tableCell">{{goals}}</td>
      <td class="tableCell">{{goalsAgainst}}</td>
      <td class="tableCell">{{difference}}</td>
      <td class="tableCell">{{points}}</td>
    </tr>
    {{/each}}
  </tbody>
</table>
</fieldset>
<br />
<br />
{{/if}}
      <fieldset>
        <legend>Spielplan

          <span style="float:right" >{{view Em.TextField id="searchField" valueBinding="view.gameFilter" placeholder="Filter nach Spielern"}}</span>
        </legend>
        <table class="table table-striped">
          <thead>
            <tr>
              <th width="70px"></th>
              <th>Heim</th>
              <th>Auswärts</th>
              {{#each attribute in App.Tournament.gameAttributes}}
                <th>{{attribute.name}}</th>
              {{/each}}
              <th>Ergebnis</th>
            </tr>
          </thead>
          {{#each matchday in filteredGames}}
            <tr><td colspan="6" class="roundSeperator">{{matchday.matchDay}}. Spieltag</td></tr>
            {{#each game in matchday.games}}
              <tr>
                <td>{{game._roundItem.name}}</td>
                <td>
                  {{view App.DynamicTextField valueBinding="game.player1.name" editableBinding="game.player1.editable"}}
                </td>
                <td>
                  {{view App.DynamicTextField valueBinding="game.player2.name" editableBinding="game.player2.editable"}}
                </td>
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
          {{/each}}
        </table>
      </fieldset>

"""

App.GamesDetailView = App.DetailView.extend
  template: Ember.Handlebars.compile gamesDetailViewTemplate
  gameFilter: ""

  didInsertElement: ->
    @_super()
    #@$().mCustomScrollbar()

  init: ->
    @_super()


