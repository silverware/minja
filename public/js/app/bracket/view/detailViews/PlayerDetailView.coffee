App.templates.playerDetail = """
  <div class="roundItemTitle">
    <div class="roundItemTitleLabel">
        <span class="round-item-name">{{view.player.name}}</span>
    </div>
  </div>


  <div class="container">
  <div class="row">
  <fieldset>
    <legend>{{App.i18n.bracket.statistic}}</legend>
    <div class="col-md-6">
      <div id="win-chart" class="center"></div>
    </div>
    <div class="col-md-6">
        <div>
          <b>{{App.i18n.bracket.games}}</b>
          <div style="display: inline-block; float: right; font-size: 12px">
            {{view.statistics.games}}/{{view.statistics.totalGames}}
          </div>
        <div class="progress">
            <div class="progress-bar progress-bar-success" style="width: {{unbound view.statistics.gamesCompletion}}%"></div>
          </div>
          </div>
          <br /> <br />
      <dl class="dl-horizontal">
      <dt>{{App.i18n.bracket.goals}}</dt>
      <dd>{{view.statistics.goals}}&nbsp;&nbsp;{{#if view.statistics.hasPlayedGames}}(&oslash;&nbsp;{{view.statistics.goalsAvg}}){{/if}}<dd>
      <dt>{{App.i18n.bracket.goalsAgainst}}</dt>
      <dd>{{view.statistics.goalsAgainst}}&nbsp;&nbsp;{{#if view.statistics.hasPlayedGames}}(&oslash;&nbsp;{{view.statistics.goalsAgainstAvg}}){{/if}}</dd>
      </dl>
    </div>
  </fieldset>
  </div>
  <div class="row">
  <fieldset>
    <legend>{{App.i18n.bracket.games}}</legend>

    <table class="table tableSchedule">
      <thead>
        <tr>
          <th class="hidden-xs" width="70px"></th>
          <th class="hidden-xs"></th>
          <th class="left">{{App.i18n.bracket.home}}</th>
          {{#if App.editable}}
            <th></th>
          {{/if}}
          <th class="left">{{App.i18n.bracket.guest}}</th>
          {{#each attribute in App.tournament.bracket.gameAttributes}}
            <th class="hidden-xs">{{attribute.name}}</th>
          {{/each}}
          <th>{{App.i18n.bracket.result}}</th>
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
              <td><i class="icon-exchange" title="{{unbound App.i18n.bracket.swapPlayers}}"{{action swapPlayers target="game"}}></i></td>
            {{/if}}
            <td {{bind-attr class="game.player2Wins:winner"}}>
              {{game.player2.name}}
            </td>
            {{#each attribute in App.tournament.bracket.gameAttributes}}
              {{view App.GameAttributeValueView classNames="hidden-xs" attributeBinding="attribute" gameBinding="game"}}
            {{/each}}
            <td style="text-align: center">
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
              {{else}}
                <b>-&nbsp;:&nbsp;-</b>
              {{/if}}
            {{/if}}
            </td>
          </tr>
        {{/each}}
      {{/each}}
    </table>
    </div></div>
"""

App.PlayerDetailView = App.DetailView.extend
  template: Ember.Handlebars.compile App.templates.playerDetail
  player: null
  statistics: null
  rounds: []

  init: ->
    @_super()
    @set 'rounds', App.tournament.bracket.getGamesByPlayer @player
    @setStatistics()

  didInsertElement: ->
    @_super()
    @renderDonutChart()

  renderDonutChart: ->
    width = 260
    height = 200
    radius = Math.min(width, height) / 2

    color = d3.scale.ordinal()
      .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"])

    arc = d3.svg.arc().outerRadius(radius - 10).innerRadius(radius - 70)

    pie = d3.layout.pie().sort(null).value((d) -> d.value)

    svg = d3.select("#win-chart").append("svg")
      .attr("width", width)
      .attr("height", height)
      .append("g")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")

    data = [
      {label: App.i18n.bracket.wins, value: @statistics.get('wins')}
      {label: App.i18n.bracket.draws, value: @statistics.get('draws')}
      {label: App.i18n.bracket.defeats, value: @statistics.get('defeats')}
    ]

    data = data.filter (value) -> value.value > 0
    noGames = false
    if data.length is 0
      noGames = true
      data.push
        label: App.i18n.bracket.games, value: 1

    g = svg.selectAll(".arc").data(pie(data)).enter().append("g").attr("class", "arc")

    g.append("path").attr("d", arc).style("fill", (d, i) -> color(i))

    g.append("text")
      .attr("transform", (d) -> "translate(" + arc.centroid(d) + ")")
      .attr("dy", ".35em")
      .style("text-anchor", "middle")
      .text((d, i) ->
        if noGames then data[i].value = 0
        data[i].label + ': ' + data[i].value)

  setStatistics: ->
    stats =
      totalGames: 0
      games: 0
      goals: 0
      goalsAgainst: 0
      wins: 0
      draws: 0
      defeats: 0
    statistics = App.tournament.bracket.get('games').reduce((statistics, game) =>
      if not game.get('players').contains @player then return statistics
      if game.get('isCompleted')
        statistics.games++
        switch game.getWinner()
          when @player then statistics.wins++
          when false then statistics.draws++
          else statistics.defeats++
        statistics.goals += game.getGoalsByPlayer @player
        statistics.goalsAgainst += game.getGoalsAgainstByPlayer @player
      statistics.totalGames++
      statistics
    , stats)
    statistics.gamesCompletion = 100 * statistics.games / statistics.totalGames
    statistics.hasPlayedGames = statistics.games > 0
    if statistics.hasPlayedGames
      statistics.goalsAvg = Math.round(statistics.goals / statistics.games * 100) / 100
      statistics.goalsAgainstAvg = Math.round(statistics.goalsAgainst / statistics.games * 100) / 100
    @set 'statistics', Ember.Object.create statistics
      
App.PlayerDetailController = Ember.Controller.extend()
