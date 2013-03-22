gameViewTemplate = """
<span>{{view DynamicTextField valueBinding="game.name" editableBinding="App.editable"}}</span>

{{#if view.round.isEditable}}
  <span class="actionIcons">
    <i class="icon-remove removeItem" {{action "remove" target="game"}}></i>
  </span>
{{/if}}

<table class="box" cellpadding="2" width="100%">
  <tr>
    <td style="min-width: 120px;" class="player tableCellBottom">
      <div id="itemIndex" class="hide">{{view.gameIndex}}</div><div id="playerIndex" class="hide">0</div>
      {{view DynamicTextField valueBinding="game.player1.name" editableBinding="game.player1.editable"}}
    </td>  
    {{#each game.games}}
      <td class="tableCellBottom">
        {{view App.NumberField valueBinding="result1" editableBinding="App.editable"}}
      </td>
    {{/each}}
  </tr>
  <tr>
    <td class="player tableCellTop">
      <div id="itemIndex" class="hide">{{view.gameIndex}}</div><div id="playerIndex" class="hide">1</div>
      {{view DynamicTextField valueBinding="game.player2.name" editableBinding="game.player2.editable"}}
    </td>
    {{#each game.games}}
      <td class="tableCellTop">
        {{view App.NumberField valueBinding="result2" editableBinding="App.editable"}}
      </td>
    {{/each}}
  </tr>
</table>
  """

App.GameView = App.RoundItemView.extend
  template: Ember.Handlebars.compile gameViewTemplate
  classNames: ['roundItem']

  round: (->
    @game?._round
    ).property("game._round")

  gameIndex: (->
      @game._round.items.indexOf(@game)
    ).property("game._round.items.@each")

