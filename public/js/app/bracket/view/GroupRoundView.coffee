App.templates.groupRound = """
{{view 'roundSetting' round=round}}

<div class="box toolbar">
      <button class="btn-inverse" id="showTables" style="display: none" {{action "displayTables" target="view"}}>
        <i class="fa fa-table"></i>
      </button>
      <button class="btn-inverse" id="showGames" {{action "displayGames" target="view"}}>
        <i class="fa fa-list"></i>
      </button>
      <button class="btn-inverse" {{action 'openRoundDetailView' view.round}}> <i class="fa fa-search"></i> </button>
  <!--<i class="fa fa-chevron-up" {{action "toggleRound" target="view"}} id="toggleRound"></i>-->
</div>

{{#each group in round.items}}
  {{view 'group' group=group showTables=view.showTables}}
{{/each}}
"""

App.GroupRoundView = App.RoundView.extend
  template: Ember.Handlebars.compile App.templates.groupRound
  showTables: true

  didInsertElement: ->
    @_super()
    @$("#showTables").tooltip
      title: App.i18n.bracket.table
      placement: 'left'
    @$("#showGames").tooltip
      title: App.i18n.bracket.schedule
      placement: 'left'

  actions:
    displayTables: ->
      @set "showTables", true
      @$("#showTables").removeClass('hide')
      @$("#showTables").hide()
      @$("#showGames").show()

    displayGames: ->
      @set "showTables", false
      @$("#showTables").show()
      @$("#showGames").removeClass('hide')
      @$("#showGames").hide()
