App.templates.game = """
<span>{{view App.DynamicTextField valueBinding="game.name" editableBinding="App.editable"}}</span>

<span class="actionIcons">
  {{#if App.editable}}
    <i class="icon-sort-up" {{action "openGameView"}}></i>
  {{/if}}
  {{#if view.round.isEditable}}
    <i class="icon-remove removeItem" {{action "remove" target="game"}}></i>
  {{/if}}
</span>

<table class="box" cellpadding="2" width="100%" id="gamesTable">
  <tr>
    <td style="min-width: 120px;" class="player tableCellBottom">
      <div id="itemIndex" class="hide">{{view.gameIndex}}</div><div id="playerIndex" class="hide">0</div>
      {{view App.DynamicTextField valueBinding="game.player1.name" editableBinding="game.player1.editable"}}
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
      {{view App.DynamicTextField valueBinding="game.player2.name" editableBinding="game.player2.editable"}}
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
  template: Ember.Handlebars.compile App.templates.game
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

  didInsertElement: ->
    @_super()
    if not App.editable  
      @$('#gamesTable').click => @openGameView()

  openGameView: ->
    App.RoundItemDetailView.create
      roundItem: @game
      table: false

  round: (->
    @game?._round
    ).property("game._round")

  gameIndex: (->
      @game._round.items.indexOf(@game)
    ).property("game._round.items.@each")

