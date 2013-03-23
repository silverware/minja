filterViewTemplate = """
<fieldset>
<legend>Spiele-Filter</legend>
  {{view Em.TextField valueBinding="view.fastSearch"}}
</fieldset>
"""

App.FilterView = Em.View.extend
  template: Ember.Handlebars.compile filterViewTemplate
  classNames: ['filterView']
  fastSearch: ""
  gameFilter: null

  didInsertElement: ->
    @_super()

  onSearch: (->
    @set "gameFilter",
      fastSearch: @get("fastSearch")
  ).observes("fastSearch")
