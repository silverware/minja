koRoundDetailViewTemplate = """

"""

App.KoRoundDetailView = App.RoundDetailView.extend
  template: Ember.Handlebars.compile koRoundDetailViewTemplate

  didInsertElement: ->
    @_super()
