App.BracketStatisticsView = Ember.View.extend
  template: Ember.Handlebars.compile """
    {{#each round in App.tournament.bracket}}
      <div>
        <b>{{round.name}}</b>
        <div style="display: inline-block; float: right; font-size: 12px">
          {{round.completion}}/{{round.gamesCount}} {{App.i18n.bracket.games}}
          <span class="seperator">|</span>
          <span title="{{unbound App.i18n.bracket.gamesPerMatch}}"># {{round.matchesPerGame}}</span>
          <span class="seperator">|</span>
          <span title="{{unbound App.i18n.bracket.qualifiers}}">
            <i class="fa fa-level-up"></i>&nbsp;{{round.qualifiers.length}}
          </span>
        </div>
        <div class="progress">
            <div class="progress-bar progress-bar-success" style="width: {{unbound round.completionRatio}}%"></div>
          </div>
      </div>
        {{#unless round.isLastRound}}
          <div style="text-align: center" >
            <i class="icon-double-angle-down"title="KO-Phase"></i>
          </div>
        {{/unless}}
    {{/each}}
    <br /><br />
  """
