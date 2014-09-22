App.Player = Em.Object.extend
  name: ""
  isDummy: false
  isPlayer: true
  isPrivate: false
  attributes: {}

  init: ->
    @_super()
    if not @id
      @set 'id', UniqueId.create()
    @attributes = Em.Object.create()

  editable: (->
    @get("isPlayer") and App.editable
  ).property("isPlayer")

  # used in Members Table
  isPartaking: (->
    _.contains App.Tournament.getPlayers(), @
  ).property('App.Tournament.@each')
  
  updateId: (->
    # TODO: set Id to Id of player in player pool with corresponding name, if exists
  ).observes('name')

App.Dummy = App.Player.extend
  isDummy: true
  isPlayer: false
