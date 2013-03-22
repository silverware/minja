App.Round = Em.Object.extend
  name: ""
  items: []
  _previousRound: null
  isNotValid: false
  editable: true
  changes: 0
  matchesPerGame: 1

  init: ->
    @_super()
    @set "items", Em.ArrayController.create
      content: []

  isEditable: (->
    App.editable and @get("editable")
  ).property("editable")

  qualifiers: (->
    qualifiers = []
    @get("items").forEach (item) ->
      Array::push.apply qualifiers, item.get("qualifiers")
    qualifiers
    ).property("items.@each.qualifiers")

  getMembers: ->
    if @get("_previousRound")
      return @get("_previousRound").get("qualifiers")
    if App.initialMembers
      return App.initialMembers
    return null

  getFreeMembers: ->
    freeMembers = null
    members = @getMembers()
    if members
      freeMembers = []
      for member in members
        if @memberNotAssigned member
          freeMembers.pushObject member
    freeMembers

  isFirstRound: =>
    !@get "_previousRound"

  isLastRound: (->
    App.Tournament.lastRound() is @
  ).property("App.Tournament.@each")

  validate: ->
    return (@getFreeMembers() is null or @getFreeMembers().length == 0) and @get("qualifiers").length > 1
    
  removeItem: (item) ->
    @items.removeObject item

  memberNotAssigned: (member) ->
    for item in @get("items").content
      if _.include(item.get("players").content, member)
        return false
    return true

  swapPlayers: (player1Index, player2Index) ->
    gamePlayers1 = @items.objectAt(player1Index[0]).players
    gamePlayers2 = @items.objectAt(player2Index[0]).players
    if gamePlayers1 == gamePlayers2
      return
      
    player1 = gamePlayers1.objectAt player1Index[1]
    player2 = gamePlayers2.objectAt player2Index[1]

    gamePlayers1.removeObject player1
    gamePlayers2.removeObject player2 

    gamePlayers1.insertAt player1Index[1], player2
    gamePlayers2.insertAt player2Index[1], player1



