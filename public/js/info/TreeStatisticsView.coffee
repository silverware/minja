define [
  "utils/EmberSerializer"
  "tree"
], (Serializer) ->

  $statisticsContent = $("#treeDashboardBox").find "fieldset"

  exports =
    init: ({data, i18n}) ->
      App.PersistanceManager.build data
      App.i18n = i18n
      App.set "rootElement", "#treeDashboardBox"
      App.initialize()
      view = Em.View.create
        template: Ember.Handlebars.compile """
          {{#each round in App.Tournament}}
            <div>
              <b>{{round.name}}</b>
              <div style="display: inline-block; float: right; font-size: 12px">
                {{round.completion}}/{{round.gamesCount}} {{App.i18n.games}}
                <span class="seperator">|</span>
                <span title="{{unbound App.i18n.gamesPerMatch}}"># {{round.matchesPerGame}}</span>
                <span class="seperator">|</span>
                <span title="{{unbound App.i18n.qualifiers}}">
                  <i class="icon-level-up"></i>&nbsp;{{round.qualifiers.length}}
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

        didInsertElement: ->
          @$().hide().fadeIn 1000
      view.appendTo("#treeDashboardBox fieldset")

