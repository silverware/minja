App.templates.dashboard = """
  settings
  aldskfj as�dlfkj

  a�dslfkjad�fl j�laskdfj �lkj


  alsdfkja dflkj
"""

App.DashboardView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.dashboard
  didInsertElement: ->
    @_super()
    console.debug "alsdfkj asd lasdkj "
    App.Observer.snapshot()

