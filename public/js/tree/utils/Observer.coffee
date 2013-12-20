window.onbeforeunload = ->
  if App.editable and App.Observer.hasChanges()
    return "You have unsaved changes!"

App.Observer =

  _snapshot: null

  snapshot: ->
    @_snapshot = App.persist()

  hasChanges: ->
    not _.isEqual @_snapshot, App.persist()
