App.ApplicationController = Ember.Controller.extend
  init: ->
    @_super()
    @initExitableView()

  initExitableView: ->
    $(document).bind "keydown", (e) =>
      if e.keyCode is 27
        @send 'closeDetailView'
        e.preventDefault()


