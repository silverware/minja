App.templates.playerDetail = """

  <!--
    TODO: Spielerstatistik: siege/un/niederlagen tore/spiel gegentore/spiel
  -->
  <div class="roundItemTitle">
    <div class="roundItemTitleLabel">
        <span class="round-item-name">{{view.player.name}}</span>
    </div>
  </div>

  <fieldset>
    <legend>{{App.i18n.games}}</legend>

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
            <th class="hidden-xs">{{attribute.name}}</th>
          {{/each}}
          <th>{{App.i18n.result}}</th>
        </tr>
      </thead>
      {{#each round in view.rounds}}
        <tr class="matchday-separator"><td colspan="15" class="matchday-separator">{{round.round.name}}</td></tr>
        {{#each game in round.games}}
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
              {{view App.GameAttributeValueView classNames="hidden-xs" attributeBinding="attribute" gameBinding="game"}}
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
"""

App.PlayerDetailView = App.DetailView.extend
  template: Ember.Handlebars.compile App.templates.playerDetail
  player: null
  rounds: []

  init: ->
    @_super()
    @set 'rounds', App.Tournament.getGamesByPlayer @player
