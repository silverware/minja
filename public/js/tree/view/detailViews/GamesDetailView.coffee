App.templates.gamesDetail = """
{{#if view.roundItem}}
  <div class="roundItemTitle">
    <div class="roundItemTitleLabel">
      <span class="carousel-control left" title="previous" {{action "navigateToLeft" target="view"}}>
        <i class="icon-arrow-left"></i>
      </span>
        {{view.roundItem.name}}
      <span class="carousel-control right" title="next" {{action "navigateToRight" target="view"}}>
        <i class="icon-arrow-right"></i>
      </span>
    </div>
  </div>
{{/if}}

{{#if view.table}}
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
        {{#each view.roundItem.table}}
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
          <td class="tableCell"><b>{{points}}</b></td>
        </tr>
        {{/each}}
      </tbody>
    </table>
  </fieldset>
  <br />
{{/if}}
  <fieldset>
    <legend>Spielplan

      <span style="float:right" >{{view Em.TextField valueBinding="view.gameFilter" placeholder="Filter nach Spielern"}}</span>
    </legend>
    <table class="table table-striped">
      <thead>
        <tr>
          <th width="70px"></th>
          <th></th>
          <th>Heim</th>
          <th>Auswärts</th>
          {{#each attribute in App.Tournament.gameAttributes}}
            <th>{{attribute.name}}</th>
          {{/each}}
          <th>Ergebnis</th>
        </tr>
      </thead>
      {{#each matchday in view.filteredGames}}
        <tr><td colspan="15" class="roundSeperator">{{matchday.matchDay}}. Spieltag</td></tr>
        {{#each game in matchday.games}}
          <tr>
            <td></td>
            <td>{{game._roundItemName}}</td>
            <td>
              {{game.player1.name}}
            </td>
            <td>
              {{game.player2.name}}
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
  template: Ember.Handlebars.compile App.templates.gamesDetail
  gameFilter: ""
