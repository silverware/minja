App.templates.group = """
  &nbsp;
  <table class="round-item-table noPadding box" id="groupTable">
    <col width="5px" />
    <col width="18px" />
    <col width="127px" />
    <col width="40px" />
    <col width="20px" />
  <thead>
    <th colspan="5">
      {{view App.DynamicTextField valueBinding="group.name" editableBinding="App.editable"}}

      <span class="actionIcons">
        {{#if App.editable}}
          <i class="fa fa-search" {{action "openGroupView" target="view"}}></i>
        {{/if}}
        {{#if view.round.isEditable}}
          <i class="fa fa-sort-up increaseQualifierCount" {{action "increaseQualifierCount" target="group"}}></i>
          <i class="fa fa-sort-down decreaseQualifierCount" {{action "decreaseQualifierCount" target="group"}}></i>
          <i class="fa fa-plus-circle increaseGroupsize" {{action "addPlayer" target="group"}}></i>
          <i class="fa fa-minus-circle decreaseGroupsize" {{action "removeLastPlayer" target="group"}}></i>
          <i class="fa fa-times removeItem" {{action "remove" target="group"}}></i>
        {{/if}}
      </span>
    </th>
  </thead>
  <tbody>
    {{#each group.table}}
      <tr {{bind-attr class="qualified:qualified :player"}}>
      <td></td>
      <td class="tableCell" style="text-align: center; vertical-align: middle">
        <div id="itemIndex" class="hide">{{view.groupIndex}}</div><div id="playerIndex" class="hide">{{index}}</div>
        {{rank}}.
      </td>
      <td class="tableCell" style="max-width: 130px">
        {{#if App.editable}}
          {{view App.DynamicTextField valueBinding="player.name" editableBinding="player.editable"}}
        {{else}}
          {{player.name}}
        {{/if}}
      </td>
      <td class="tableCell" style="text-align: center; vertical-align: middle">{{goals}} : {{goalsAgainst}}</td>
      <td class="tableCell" style="text-align: center; vertical-align: middle; font-weight: bold;">{{points}}</td>
    </tr>
    {{/each}}
  </tbody>
</table>

  <table class="table noPadding groupGames box hide" id="groupGames">
  <col width="80px" />
  <col width="8px" />
  <col width="80px" />
  <col width="50px" />
{{#each view.games}}
  {{#if newRound}}
    <tr>
      <td colspan="9" class="roundSeperator"></td>
    </tr>
  {{/if}}
  <tr class="game">
    <td title="{{unbound game.player1.name}}" style="text-align: right; padding-left: 3px !important" class="tableCell">
      <div id="gameIndex" class="hide">{{gameIndex}}</div>
      {{game.player1.name}}
    </td>
    <td style="text-align: center" class="tableCell">:</td>
    <td class="tableCell" title="{{unbound game.player2.name}}">
      {{game.player2.name}}
    </td>
    <td class="tableCell" style="text-align: center">
      {{view App.NumberField editableBinding="App.editable" valueBinding="game.result1"}} : {{view App.NumberField valueBinding="game.result2" editableBinding="App.editable"}}
    </td>
  </tr>
{{/each}}
</table>
"""


App.GroupView = App.RoundItemView.extend
  template: Ember.Handlebars.compile App.templates.group
  classNames: ['group roundItem']

  round: (->
    @group?._round
  ).property("group._round")

  didInsertElement: ->
    @_super()
    @$(".increaseGroupsize").tooltip
      title: App.i18n.groupSizeUp
    @$(".decreaseGroupsize").tooltip
      title: App.i18n.groupSizeDown
    @$(".increaseQualifierCount").tooltip
      title: App.i18n.qualifiersUp
    @$(".decreaseQualifierCount").tooltip
      title: App.i18n.qualifiersDow
    @toggleTableGames()

    if App.editable
      @initGameDraggable()
    else
      @$('#groupTable').addClass 'blurringBox'
      @$('#groupGames').addClass 'blurringBox'
      @$('#groupTable').click => @openGroupView()
      @$('#groupGames').click => @openGroupView()

  # Wettlauf beachten
  onRedrawTable: (->
    if @get("round").get("isEditable")
      setTimeout((=> @initDraggable()), 50)
  ).observes("group.table")

  onRedrawGames: (->
    # if @get("round").get("isEditable")
    if App.editable
      setTimeout((=> @initGameDraggable()), 50)
  ).observes("games")

  toggleTableGames: (->
    if @get("showTables")
      @toggle "#groupGames", "#groupTable"
    else
      @toggle "#groupTable", "#groupGames"
  ).observes("showTables")

  openGroupView: ->
    App.RoundItemDetailView.create
      roundItem: @group
      table: true


  toggle: (outId, inId) ->
    @$(outId).fadeOut "fast", =>
      @$(inId).removeClass('hide')
      @$(inId).fadeIn "medium"

  groupIndex: (->
    @group._round.items.indexOf @group
  ).property("group.round.items.@each")

  games: (->
    games = []
    gamesPerRound = Math.floor(@group.players.get("length") / 2)
    for index in [0..@group.games.get("length") - 1]
      games.pushObject
        game: @get("group.games").objectAt index
        gameIndex: index
        newRound: index != 0 and (index + gamesPerRound) % gamesPerRound == 0
    games
  ).property("group.games.@each")

  initGameDraggable: ->
    @$(".game").css "cursor", "move"
    @$(".game").draggable
      containment: @$()
      helper: 'clone'
      revert: 'invalid'
      start: (e, {helper}) ->
        $(helper).addClass "ui-draggable-helper"
      #stop: =>
      #  setTimeout (=> @draggable true), 20

    @$(".game").droppable
      drop: (event, ui) =>
        dragElement = $ ui.draggable[0]
        dropElement = $ event.target
        @get("group").swapGames(
          parseInt(dragElement.find("#gameIndex")[0].textContent),
          parseInt(dropElement.find("#gameIndex")[0].textContent))

