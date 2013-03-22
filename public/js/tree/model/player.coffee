App.Player = Em.Object.extend
  name: ""
  isDummy: false
  isPlayer: true

  init: ->
  	@_super()
  	@id = UniqueId.create()

  editable: (->
    @get("isPlayer") and App.editable
  ).property("isPlayer")

App.Dummy = App.Player.extend
  isDummy: true
  isPlayer: false
