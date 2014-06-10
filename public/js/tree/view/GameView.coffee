App.templates.game = """

<table class="box {{unbound game.itemId}} round-item-table noPadding" cellpadding="2" width="100%" id="gamesTable">
  <thead>
    <th colspan="10">
      <span>{{view App.DynamicTextField valueBinding="game.name" editableBinding="App.editable"}}</span>

      <span class="actionIcons">
        {{#if App.editable}}
          <i class="fa fa-search" {{action "openGameView" target="view"}}></i>
        {{/if}}
        {{#if view.round.isEditable}}
          <i class="fa fa-times removeItem" {{action "remove" target="game"}}></i>
        {{/if}}
      </span>
    </th>
  </thead>
  <tr>
    <td style="width: 5px">&nbsp;</td>
    <td style="max-width: 110px; width: 110px" class="player tableCellBottom" title="{{unbound game.player1.name}}">
      <div id="itemIndex" class="hide">{{view.gameIndex}}</div><div id="playerIndex" class="hide">0</div>
      {{#if App.editable}}
        {{view App.DynamicTextField valueBinding="game.player1.name" editableBinding="game.player1.editable"}}
      {{else}}
        {{game.player1.name}}
      {{/if}}
    </td>
    {{#each g in game.games}}

      <td class="tableCellBottom">
        {{view App.GameResultView playerBinding="game.player1" gBinding="g"}}
      </td>
    {{/each}}
  </tr>
  <tr>
    <td style="width: 5px">&nbsp;</td>
    <td style="max-width: 110px; width: 110px" class="player tableCellTop" title="{{unbound game.player2.name}}">
      <div id="itemIndex" class="hide">{{view.gameIndex}}</div><div id="playerIndex" class="hide">1</div>
      {{#if App.editable}}
        {{view App.DynamicTextField valueBinding="game.player2.name" editableBinding="game.player2.editable"}}
      {{else}}
        {{game.player2.name}}
      {{/if}}
    </td>
    {{#each g in game.games}}
      <td class="tableCellTop">
        {{view App.GameResultView playerBinding="game.player2" gBinding="g"}}
      </td>
    {{/each}}
  </tr>
</table>
  """

App.GameView = App.RoundItemView.extend
  template: Ember.Handlebars.compile App.templates.game
  classNames: ['roundItem']

  didInsertElement: ->
    @_super()
    if not App.editable
      @$('#gamesTable').addClass 'blurringBox'
      @$('#gamesTable').click => @openGameView()

  openGameView: ->
    App.RoundItemDetailView.create
      roundItem: @get("game")
      table: false

  round: (->
    @game?._round
  ).property("game._round")

  gameIndex: (->
    @game._round.items.indexOf @game
  ).property("game._round.items.@each")

  itemId: (->
    @game.getId()
  ).property("game._round.items.@each")


App.GameResultView = Em.View.extend
  template: Ember.Handlebars.compile """
    {{view App.NumberField valueBinding="view.result" editableBinding="App.editable"}}
  """

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
  ).property("player", "g.result1", "g.result2")
