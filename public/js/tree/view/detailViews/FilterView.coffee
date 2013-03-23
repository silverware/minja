filterViewTemplate = """
<fieldset>
<legend>Spiele-Filter</legend>
  {{view Em.TextField valueBinding="fastSearch"}}
</fieldset>
"""

App.FilterView = App.FilterView.extend
  template: Ember.Handlebars.compile filterViewTemplate
  fastSearch: ""

  didInsertElement: ->
    @_super()

  onSearch: (->
    console.debug "search changed"
  ).observes("fastSearch")
