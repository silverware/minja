App.templates.groupRound = """
{{view App.RoundSetting roundBinding="round"}}

<div class="box toolbar">
  <i class="fa fa-table" {{action "displayTables" target="view"}} id="showTables" style="display: none"></i>
  <i class="fa fa-list" {{action "displayGames" target="view"}} id="showGames"></i>
  <i id="openDetailView" class="fa fa-search"></i>
  <!--<i class="fa fa-chevron-up" {{action "toggleRound" target="view"}} id="toggleRound"></i>-->
</div>

{{#each group in round.items}}
  {{view App.GroupView groupBinding="group" showTablesBinding="view.showTables"}}
{{/each}}
"""

App.GroupRoundView = App.RoundView.extend
  template: Ember.Handlebars.compile App.templates.groupRound
  showTables: true

  didInsertElement: ->
    @_super()
    @$("#showTables").tooltip
      title: App.i18n.table
      placement: 'left'
    @$("#showGames").tooltip
      title: App.i18n.schedule
      placement: 'left'

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
