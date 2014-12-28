App.LoadingView = Em.View.extend
  template: Ember.Handlebars.compile """
    loading...
    """

  didInsertElement: ->
    @_super()
