App.templates.group = """
  <table {{bind-attr class=":round-item-table :noPadding :box editable::blurringBox"}} id="groupTable" {{action 'tableClicked' target='view'}}>
    <col width="18px" />
    <col width="147px" />
    <col width="20px" />
  <thead>
    <th colspan="5">
      {{view 'dynamicTextField' value=group.name editable=App.editable}}

      <span class="actionIcons">
        {{#if App.editable}}
          <i class="fa fa-search" {{action "openGroupDetailView" group}}></i>
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
      <td class="tableCell" style="text-align: center; vertical-align: middle">
        <div id="itemIndex" class="hide">{{view.groupIndex}}</div><div id="playerIndex" class="hide">{{index}}</div>
        {{rank}}.
      </td>
      <td class="tableCell" style="max-width: 130px">
        {{#if App.editable}}
          {{view 'dynamicTextField' value=player.name editable=player.editable}}
        {{else}}
          {{player.name}}
        {{/if}}
      </td>
      <td class="tableCell" style="text-align: center; vertical-align: middle; font-weight: bold;">{{points}}</td>
    </tr>
    {{/each}}
  </tbody>
</table>

  <table {{bind-attr class=":table :round-item-table :noPadding :groupGames :box :hide editable::blurringBox"}} id="groupGames" {{action 'tableClicked' target='view'}}>
  <col width="70px" />
  <col width="8px" />
  <col width="70px" />
  <col width="50px" />
  <thead>
    <th colspan="4">
      {{view 'dynamicTextField' value=group.name editable=App.editable}}
    </th>
  </thead>
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
      {{view 'numberField' editable=App.editable value=game.result1}} : {{view 'numberField' value=game.result2 editable=App.editable}}
    </td>
  </tr>
{{/each}}
</table>
"""


App.GroupView = App.RoundItemView.extend Ember.TargetActionSupport,
  template: Ember.Handlebars.compile App.templates.group
  classNames: ['group roundItem']

  round: (->
    @group?._round
  ).property("group._round")

  actions:
    tableClicked: ->
      if not App.editable
        @triggerAction
          action: 'openGroupDetailView'
          actionContext: @get('group')
          target: @get('controller')


  didInsertElement: ->
    @_super()
    @$(".increaseGroupsize").tooltip
      title: App.i18n.bracket.groupSizeUp
    @$(".decreaseGroupsize").tooltip
      title: App.i18n.bracket.groupSizeDown
    @$(".increaseQualifierCount").tooltip
      title: App.i18n.bracket.qualifiersUp
    @$(".decreaseQualifierCount").tooltip
      title: App.i18n.bracket.qualifiersDow
    @toggleTableGames()

    if App.editable
      @initGameDraggable()
    else
      @$('#groupTable').addClass 'blurringBox'
      @$('#groupGames').addClass 'blurringBox'

  # Wettlauf beachten
  onRedrawTable: (->
    if @get("isDraggable")
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

