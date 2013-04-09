define [
  "utils/EmberSerializer"
  "tree"
], (Serializer) ->

  $statisticsContent = $("#treeDashboardBox").find "fieldset"

  exports =
    init: ({data, i18n}) ->
      App.PersistanceManager.build data
      App.i18n = i18n
      App.Tournament
      view = Em.View.create
        template: Ember.Handlebars.compile """
          {{#each round in App.Tournament}}
            <div>
              {{#if round.isGroupRound}}
                <i class="icon-group" title="Gruppenphase"></i>
              {{/if}}
              {{#if round.isKoRound}}
                <i class="icon-exchange" title="KO-Phase"></i>
              {{/if}}
              <b>{{round.name}}</b>
              <div style="display: inline-block; float: right">
                <span title="Games">{{round.gamesCount}} {{App.i18n.games}}</span>
                <span class="seperator">|</span>
                <span title="Games/Match"># {{round.matchesPerGame}}</span>
                <span class="seperator">|</span>
                {{round.qualifiers.length}} {{App.i18n.qualifiers}}<br />
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
        classNames: ['hide']

        didInsertElement: ->
          @$().fadeIn 1000
      view.appendTo("#treeDashboardBox fieldset")

