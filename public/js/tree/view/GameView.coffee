gameViewTemplate = """
<span>{{view DynamicTextField valueBinding="game.name" editableBinding="App.editable"}}</span>

{{#if view.round.isEditable}}
  <span class="actionIcons">
    <i class="icon-remove removeItem" {{action "remove" target="game"}}></i>
  </span>
{{/if}}

<table class="box" cellpadding="2" width="100%" {{action "openRoundItemView"}}>
  <tr>
    <td style="min-width: 120px;" class="player tableCellBottom">
      <div id="itemIndex" class="hide">{{view.gameIndex}}</div><div id="playerIndex" class="hide">0</div>
      {{view DynamicTextField valueBinding="game.player1.name" editableBinding="game.player1.editable"}}
    </td>  
    {{#each g in game.games}}
      <td class="tableCellBottom">
        {{#view view.resultView playerBinding="game.player1" gBinding="g"}}
          {{view App.NumberField valueBinding="view.result" editableBinding="App.editable"}}
        {{/view}}
      </td>
    {{/each}}
  </tr>
  <tr>
    <td class="player tableCellTop">
      <div id="itemIndex" class="hide">{{view.gameIndex}}</div><div id="playerIndex" class="hide">1</div>
      {{view DynamicTextField valueBinding="game.player2.name" editableBinding="game.player2.editable"}}
    </td>
    {{#each g in game.games}}
      <td class="tableCellTop">
        {{#view view.resultView playerBinding="game.player2" gBinding="g"}}
          {{view App.NumberField valueBinding="view.result" editableBinding="App.editable"}}
        {{/view}}
      </td>
    {{/each}}
  </tr>
</table>
  """

App.GameView = App.RoundItemView.extend
  template: Ember.Handlebars.compile gameViewTemplate
  classNames: ['roundItem']

  resultView: Em.View.extend
    player: null
    g: null

    result: ((key, value) ->
      if @get("g.player1") is @get("player")
        index = "1"
      else
        index = "2"

      # GETTER
      if arguments.length == 1
        return @get("g.result#{index}")
      # SETTER
      else
        @get("g").set "result#{index}", value
    ).property("player", "g")

  openRoundItemView: ->
    App.RoundItemDetailView.create
      roundItem: @game

  round: (->
    @game?._round
    ).property("game._round")

  gameIndex: (->
      @game._round.items.indexOf(@game)
    ).property("game._round.items.@each")

