App.templates.dashboard = """
  settings
  aldskfj asödlfkj

  aödslfkjadöfl jölaskdfj ölkj


  alsdfkja dflkj
"""

App.DashboardView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.dashboard
  didInsertElement: ->
    @_super()
    console.debug "alsdfkj asd lasdkj "
    App.Observer.snapshot()

