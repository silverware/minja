App.templates.settings = """
  settings
"""

App.SettingsView = Em.View.extend

  template: Ember.Handlebars.compile App.templates.settings
  didInsertElement: ->
    @$().hide()
    $('.spinner-wrapper').fadeOut 'fast', =>
      @$().fadeIn 1000
    @$("[rel='tooltip']").tooltip()
    App.Observer.snapshot()

