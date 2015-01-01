App.ApplicationView = Em.View.extend
  defaultTemplate: Ember.Handlebars.compile """
    {{outlet}}
    {{outlet 'detailView1'}}
    {{outlet 'detailView2'}}
    {{outlet 'detailView3'}}
    """

  didInsertElement: ->
    @_super()
    $('.loading-screen').hide()
