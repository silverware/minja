App.templates.infoEdit = """
alsdfkj
"""

App.InfoEditView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.infoEdit

  didInsertElement: ->
    @_super()

