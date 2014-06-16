App.Player = Em.Object.extend
  name: ""
  isDummy: false
  isPlayer: true
  attributes: {}

  init: ->
    @_super()
    @id = UniqueId.create()
    @attributes = Em.Object.create()

  editable: (->
    @get("isPlayer") and App.editable
  ).property("isPlayer")
  
  updateId: (->
    # TODO: set Id to Id of player in player pool with corresponding name, if exists
  ).observes('name')

App.Dummy = App.Player.extend
  isDummy: true
  isPlayer: false
