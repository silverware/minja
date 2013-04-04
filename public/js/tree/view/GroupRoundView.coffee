App.templates.groupRound = """
{{view App.RoundSetting roundBinding="round"}}

<div id="toolbar">
  <i class="icon-th-list" {{action "displayTables"}} id="showTables" style="display: none"></i>
  <i class="icon-fullscreen" {{action "displayGames"}} id="showGames"></i>
  <i id="openDetailView" class="icon-search"></i>
  <i class="icon-chevron-up" {{action "toggleRound"}} id="toggleRound"></i>
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
      title: "Tabellenansicht"
    @$("#showGames").tooltip
      title: "Spielplanansicht"

  displayTables: ->
    @set "showTables", true
    @$("#showTables").hide()
    @$("#showGames").show()

  displayGames: ->
    @set "showTables", false
    @$("#showTables").show()
    @$("#showGames").hide()