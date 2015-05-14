App.templates.gamesDetail = """
  <div class="roundItemTitle">
    <div class="roundItemTitleLabel">
      {{#if roundItem}}
        <span class="left noPrint" title="previous" {{action "navigateToLeft"}}>
          <i class="fa fa-arrow-circle-left"></i>
        </span>

        <span class="round-item-name">{{roundItem.name}}</span>

        <span class="right noPrint" title="next" {{action "navigateToRight"}}>
          <i class="fa fa-arrow-circle-right"></i>
        </span>
      {{/if}}
    </div>
  </div>
    <div class="noPrint actionButtons">
      <span title="print" class="printView hidden-xs hidden-sm" {{action "printView"}}>
        <i class="fa fa-print"></i>
      </span><!--
      <span title="prefill Attributes" class="carousel-control prefillAttributesView" {{action "prefillAttributes" target="view"}}>
        <i class="fa fa-check"></i>
      </span>-->
    </div>

    <div class="container">
    <div class="row">
{{#if renderTable}}
  <fieldset>
    <legend>{{i18n.bracket.table}}</legend>

    <table class="table tableTable col-md-8 col-xs-12">
      <thead>
        <tr>
          <th width="20px">{{i18n.bracket.rank}}</th>
          <th style="text-align: left">Name</th>
          <th>{{i18n.bracket.games}}</th>
          <th class="hidden-xs" style="cursor: help" title="{{unbound i18n.bracket.wins}}">{{i18n.bracket.winsShort}}</th>
          <th class="hidden-xs" style="cursor: help" title="{{unbound i18n.bracket.draws}}">{{i18n.bracket.drawsShort}}</th>
          <th class="hidden-xs" style="cursor: help" title="{{unbound i18n.bracket.defeats}}">{{i18n.bracket.defeatsShort}}</th>
          <th style="cursor: help" title="{{unbound i18n.bracket.goals}}">{{i18n.bracket.goalsShort}}</th>
          <th style="cursor: help" class="hidden-xs" title="{{unbound i18n.bracket.difference}}">+/-</th>
          <th>{{i18n.bracket.points}}</th>
        </tr>
      </thead>
      <tbody>
        {{#each roundItem.table}}
          <tr {{bind-attr class=":player qualified:qualified"}} {{action "openPlayerDetailView" player}}>
          <td class="rank-cell">
            {{rank}}.
          </td>
          <td style="text-align: left">
            {{#if App.editable}}
              {{view 'dynamicTextField' value=player.name classNames="xl" editable=player.editable}}
            {{else}}
              <div class="input-padding"><a href="#" >{{player.name}}</a></div>
            {{/if}}
          </td>
          <td>{{games}}</td>
          <td class="hidden-xs">{{wins}}</td>
          <td class="hidden-xs">{{draws}}</td>
          <td class="hidden-xs">{{defeats}}</td>
          <td>{{goals}} : {{goalsAgainst}}</td>
          <td class="hidden-xs">{{difference}}</td>
          <td><b>{{points}}</b></td>
        </tr>
        {{/each}}
      </tbody>
    </table>
  </fieldset>
  <br />
{{/if}}
  <fieldset>
    <legend>{{i18n.bracket.schedule}}
      <span style="font-size: 1rem; float:right; margin-bottom: 5px;" class="hidden-xs" class="noPrint">
        {{view 'filterButton' content=filterOptions value=gamesPlayedFilter}}
        {{view 'searchTextField' value=gameFilter placeholder="Filter ..."}}
      </span>
    </legend>
    <table class="table tableSchedule">
      <thead class="hidden-xs">
        <tr>
          <th class="hidden-xs" width="70px"></th>
          <th class="hidden-xs"></th>
          <th style="text-align: left">{{i18n.bracket.home}}</th>
          {{#if App.editable}}
            <th></th>
          {{/if}}
          <th style="text-align: left">{{i18n.bracket.guest}}</th>
          {{#each attribute in bracket.gameAttributes}}
            <th class="hidden-xs">{{attribute.name}}</th>
          {{/each}}
          <th>{{i18n.bracket.result}}</th>
        </tr>
      </thead>
      {{#each matchday in filteredGames}}
        <tbody style="page-break-after: always">
        <tr class="matchday-separator"><td colspan="15" class="matchday-separator">{{matchday.matchDay}}. {{i18n.bracket.matchday}}</td></tr>
        {{#each game in matchday.games}}
          <tr>
            <td class="hidden-xs"></td>
            <td class="hidden-xs rank-cell">{{game._roundItemName}}</td>
            <td {{bind-attr class="game.player1Wins:winner"}}>
              <a href="#" {{action "openPlayerDetailView" game.player1}}>{{game.player1.name}}</a>
            </td>
            {{#if App.editable}}
              <td><i class="fa fa-exchange" title="{{unbound i18n.bracket.swapPlayers}}"{{action swapPlayers target="game"}}></i></td>
            {{/if}}
            <td {{bind-attr class="game.player2Wins:winner"}}>
              <a href="#" {{action "openPlayerDetailView" game.player2}}>{{game.player2.name}}</a>
            </td>
            {{#each attribute in bracket.gameAttributes}}
              {{view 'gameAttributeValue' classNames="hidden-xs" attribute=attribute game=game}}
            {{/each}}
            <td class="center">
            {{#if App.editable}}
                <div class="result-container">
                {{view 'numberField' classNames="form-control" editable=App.editable value=game.result1}}
                </div>
                &nbsp;
                <div class="result-container">
                {{view 'numberField' classNames="form-control" editable=App.editable value=game.result2}}
                </div>
            {{else}}
              {{#if game.isCompleted}}
                <b>{{game.result1}} : {{game.result2}}</b>
              {{else}}
                <b>-&nbsp;:&nbsp;-</b>
              {{/if}}
            {{/if}}
            </td>
          </tr>
        {{/each}}
        </tbody>
      {{/each}}
    </table>
  </fieldset>
    </div></div>
"""

App.GamesDetailView = App.DetailView.extend
  temp: """
    <div style="text-align: right" class="noPrint"><em>{{gamesCount}} {{i18n.bracket.games}}</em></div>
  """
  classNameBinding: ['hide:hide']
  template: Ember.Handlebars.compile App.templates.gamesDetail


App.GamesDetailController = Ember.Controller.extend
  gameFilter: ""
  gamesPlayedFilter: undefined

  init: ->
    @_super()
    @set 'filterOptions', [
      {id: undefined, label: App.i18n.bracket.all}
      {id: true, label: App.i18n.bracket.played}
      {id: false, label: App.i18n.bracket.open}
    ]

  actions:
    openPlayerDetailView: (player) ->
      @send 'openDetailView', 'playerDetail',
        player: player
        editable: App.editable
    printView: ->
      window.print()
