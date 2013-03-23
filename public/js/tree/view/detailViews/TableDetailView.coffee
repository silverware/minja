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
    {{#each group.table}}
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


</fieldset>
"""

App.TableDetailView = App.DetailView.extend
  template: Ember.Handlebars.compile tableDetailViewTemplate
  group: null

  didInsertElement: ->
    @_super()
