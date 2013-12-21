window.onbeforeunload = ->
  if App.editable and App.Observer.hasChanges()
    return App.i18n.unsavedChanges

App.Observer =

  _snapshot: null

  snapshot: ->
    @_snapshot = App.persist()

  hasChanges: ->
    not _.isEqual @_snapshot, App.persist()
