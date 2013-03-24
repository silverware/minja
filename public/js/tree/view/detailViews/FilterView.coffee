filterViewTemplate = """
<fieldset>
<legend>Filter</legend>
  {{view Em.TextField id="searchField" valueBinding="view.fastSearch" placeholder="Filter nach Spielern"}}
</fieldset>
"""

App.FilterView = Em.View.extend
  template: Ember.Handlebars.compile filterViewTemplate
  classNames: ['filterView']
  fastSearch: ""
  gameFilter: null

  didInsertElement: ->
    @_super()
    $(document).keydown =>
      @$("#searchField")?.focus()

  onSearch: (->
    @set "gameFilter",
      fastSearch: @get("fastSearch")
  ).observes("fastSearch")
