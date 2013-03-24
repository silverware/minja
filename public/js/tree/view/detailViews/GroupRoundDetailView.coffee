groupRoundDetailViewTemplate = """
"""

App.GroupRoundDetailView = App.RoundDetailView.extend
  template: Ember.Handlebars.compile groupRoundDetailViewTemplate


  didInsertElement: ->
    @_super()