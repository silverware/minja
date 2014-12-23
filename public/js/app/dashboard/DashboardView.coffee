App.templates.dashboard = """
  settings
"""

App.DashboardView = Em.View.extend

  template: Ember.Handlebars.compile App.templates.dashboard
  didInsertElement: ->
    @$().hide()
    $('.spinner-wrapper').fadeOut 'fast', =>
      @$().fadeIn 1000
    @$("[rel='tooltip']").tooltip()
    App.Observer.snapshot()

