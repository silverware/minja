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
            <div style="text-align: center">
              <b>{{round.name}}</b>
              <span class="seperator">|</span>
              {{#if round.isGroupRound}}
                <i class="icon-group" title="Gruppenphase"></i>
              {{/if}}
              {{#if round.isKoRound}}
                <i class="icon-exchange" title="KO-Phase"></i>
              {{/if}}
              <span class="seperator">|</span>
              <span title="Games/Match"># {{round.matchesPerGame}}</span>
              <span class="seperator">|</span>
              {{round.qualifiers.length}} {{App.i18n.qualifiers}}<br />
              {{#unless round.isLastRound}}
                <i class="icon-double-angle-down" title="KO-Phase"></i>
              {{/unless}}
            </div>
          {{/each}}
          <br /><br />
        """
        classNames: ['hide']

        didInsertElement: ->
          @$().fadeIn 1000
      view.appendTo("#treeDashboardBox fieldset")

