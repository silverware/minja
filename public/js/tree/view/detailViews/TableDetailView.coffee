tableDetailViewTemplate = """
<fieldset>
<legend>Tabelle</legend>

<table class="table" style="max-width: 800px; margin: 0 auto;">
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
        {{view DynamicTextField valueBinding="player.name" editableBinding="player.editable"}}
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

<fieldset>
<legend>Kreuztabelle</legend>

<table class="table">
  <tr>
    <td></td>
    {{#each player in roundItem.players}}
      <td>{{player.name}}</td>
    {{/each}}
  </tr>
  {{#each player1 in roundItem.players}}
    <tr>
      <td>{{player1.name}}</td>
      {{#each player2 in roundItem.players}}
        <td>{{#view view.resultsView player1Binding="player1" player2Binding="player2" groupBinding="roundItem"}}
          {{#each view.results}}
            {{#if block}}black{{/if}}
            {{#unless block}}
            {{result1}}:{{result2}}
            {{/unless}}
          {{/each}}
        {{/view}}</td>
      {{/each}}
    </tr>
  {{/each}}
</table>

</fieldset>
"""

App.TableDetailView = App.RoundItemDetailView.extend
  template: Ember.Handlebars.compile tableDetailViewTemplate

  didInsertElement: ->
    @_super()

  resultsView: Em.View.extend
    player1: null
    player2: null
    group: null

    results: (->
      results = []
      if @get("player1") is @get("player2")
        results.push block: true
        return results
      @get("group.games").forEach (game) =>
        if game.player1 is @get("player1") and game.player2 is @get("player2")
          results.pushObject game
      results
    ).property("player1", "player2", "group.games.@each")