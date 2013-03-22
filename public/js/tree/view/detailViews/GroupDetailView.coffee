groupDetailViewTemplate = """
<table class="table">
  <tbody>
    {{#each group.table}}
      {{#if qualified}}
        <tr class="player qualified" >
      {{else}}
        <tr class="player">
      {{/if}}
      <td class="tableCell" style="text-align: center; vertical-align: middle">
        <div id="itemIndex" class="hide">{{view.groupIndex}}</div><div id="playerIndex" class="hide">{{index}}</div>
        {{rank}}.
      </td>
      <td class="tableCell reallyNoPadding">
        {{view DynamicTextField valueBinding="player.name" editableBinding="player.editable"}}
      </td>
      <td class="tableCell" style="text-align: center; vertical-align: middle">{{goals}} : {{goalsAgainst}}</td>
      <td class="tableCell" style="text-align: center; vertical-align: middle; font-weight: bold;">{{points}}</td>
    </tr>
    {{/each}}
  </tbody>
</table>



Kreuztabelle
"""

App.GroupDetailView = App.DetailView.extend
  template: Ember.Handlebars.compile groupDetailViewTemplate
  group: null

  didInsertElement: ->
    @_super()
