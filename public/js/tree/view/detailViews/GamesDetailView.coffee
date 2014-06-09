App.templates.gamesDetail = """
  <div class="roundItemTitle">
    <div class="roundItemTitleLabel">
      {{#if view.roundItem}}
        <span class="left noPrint" title="previous" {{action "navigateToLeft" target="view"}}>
          <i class="fa fa-arrow-circle-left"></i>
        </span>

        <span class="round-item-name">{{view.roundItem.name}}</span>

        <span class="right noPrint" title="next" {{action "navigateToRight" target="view"}}>
          <i class="fa fa-arrow-circle-right"></i>
        </span>
      {{/if}}
    </div>
  </div>
    <div class="noPrint actionButtons">
      <span title="print" class="printView hidden-xs hidden-sm" {{action "printView" target="view"}}>
        <i class="fa fa-print"></i>
      </span><!--
      <span title="prefill Attributes" class="carousel-control prefillAttributesView" {{action "prefillAttributes" target="view"}}>
        <i class="icon-ok"></i>
      </span>-->
    </div>

{{#if view.table}}
  <fieldset>
    <legend>{{App.i18n.table}}</legend>

    <div class="container">
    <div class="row">
    <table class="table tableTable col-md-8 col-xs-12">
      <thead>
        <tr>
          <th>{{App.i18n.rank}}</th>
          <th style="text-align: left">Name</th>
          <th>{{App.i18n.games}}</th>
          <th style="cursor: help" title="{{unbound App.i18n.wins}}">{{App.i18n.winsShort}}</th>
          <th style="cursor: help" title="{{unbound App.i18n.draws}}">{{App.i18n.drawsShort}}</th>
          <th style="cursor: help" title="{{unbound App.i18n.defeats}}">{{App.i18n.defeatsShort}}</th>
          <th style="cursor: help" title="{{unbound App.i18n.goals}}">{{App.i18n.goalsShort}}</th>
          <th style="cursor: help" class="hidden-xs" title="{{unbound App.i18n.difference}}">+/-</th>
          <th>{{App.i18n.points}}</th>
        </tr>
      </thead>
      <tbody>
        {{#each view.roundItem.table}}
          <tr {{bind-attr class=":player qualified:qualified"}} >
          <td>
            {{rank}}.
          </td>
          <td style="text-align: left">
            {{#if App.editable}}
              {{view App.DynamicTextField valueBinding="player.name" classNames="xl" editableBinding="player.editable"}}
            {{else}}
              <div class="input-padding">{{player.name}}</div>
            {{/if}}
          </td>
          <td>{{games}}</td>
          <td>{{wins}}</td>
          <td>{{draws}}</td>
          <td>{{defeats}}</td>
          <td>{{goals}} : {{goalsAgainst}}</td>
          <td class="hidden-xs">{{difference}}</td>
          <td><b>{{points}}</b></td>
        </tr>
        {{/each}}
      </tbody>
    </table>
    </div>
    </div>
  </fieldset>
  <br />
{{/if}}
  <fieldset>
    <legend>{{App.i18n.schedule}}

      <span style="float:right" class="noPrint">
        {{view App.SearchTextField valueBinding="view.gameFilter" placeholder="Filter ..."}}
      </span>
    </legend>
    <table class="table tableSchedule">
      <thead>
        <tr>
          <th class="hidden-xs" width="70px"></th>
          <th class="hidden-xs"></th>
          <th>{{App.i18n.home}}</th>
          {{#if App.editable}}
            <th></th>
          {{/if}}
          <th>{{App.i18n.guest}}</th>
          {{#each attribute in App.Tournament.gameAttributes}}
            <th>{{attribute.name}}</th>
          {{/each}}
          <th>{{App.i18n.result}}</th>
        </tr>
      </thead>
      {{#each matchday in view.filteredGames}}
        <tr class="matchday-separator"><td colspan="15" class="matchday-separator">{{matchday.matchDay}}. {{App.i18n.matchday}}</td></tr>
        {{#each game in matchday.games}}
          <tr>
            <td class="hidden-xs"></td>
            <td class="hidden-xs">{{game._roundItemName}}</td>
            <td {{bind-attr class="game.player1Wins:winner"}}>
              {{game.player1.name}}
            </td>
            {{#if App.editable}}
              <td><i class="icon-exchange" title="{{unbound App.i18n.swapPlayers}}"{{action swapPlayers target="game"}}></i></td>
            {{/if}}
            <td {{bind-attr class="game.player2Wins:winner"}}>
              {{game.player2.name}}
            </td>
            {{#each attribute in App.Tournament.gameAttributes}}
              {{view App.GameAttributeValueView attributeBinding="attribute" gameBinding="game"}}
            {{/each}}
            <td>
            {{#if App.editable}}
                <div class="result-container">
                {{view App.NumberField classNames="form-control" editableBinding="App.editable" valueBinding="game.result1"}}
                </div>
                &nbsp;
                <div class="result-container">
                {{view App.NumberField classNames="form-control" editableBinding="App.editable" valueBinding="game.result2"}}
                </div>
            {{else}}
              {{#if game.isCompleted}}
                <b>{{game.result1}} : {{game.result2}}</b>
              {{/if}}
            {{/if}}
            </td>
          </tr>
        {{/each}}
      {{/each}}
    </table>
    <div style="text-align: right" class="noPrint"><em>{{view.gamesCount}} {{App.i18n.games}}</em></div>
  </fieldset>
"""

App.GamesDetailView = App.DetailView.extend
  template: Ember.Handlebars.compile App.templates.gamesDetail
  gameFilter: ""

  printView: ->
    window.print()

  gamesCount: (->
    @get('filteredGames').reduce (count, matchDay) ->
      count += matchDay.games.length
    , 0
  ).property("filteredGames")
