App.GroupRound = App.Round.extend
  _itemLabel: ""
  isGroupRound: true

  _letters: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  init: ->
    @_super()
    @_itemLabel = App.i18n.group

  addItem: ->
    if not @get('editable')
      App.Popup.showInfo
        bodyContent: App.i18n.roundItemNotAddable
      return
    
    group = App.Group.create
      name:"#{App.i18n.group} " + @_letters[@get('items.length')]
      _round: @
    
    # apply settings of previous group (playercount and qualifiercount)
    prevGroup = @get('items.lastObject')
    if prevGroup
      group.set "qualifierCount", prevGroup.get("qualifierCount")
      prevPlayersLength = prevGroup.get("players.length")

    playersCount = (prevPlayersLength - 1) or 3

    players = []
    for i in [0..playersCount]
      if @getFreeMembers()?[i]?
        players.pushObject @getFreeMembers()[i]
      else
        players.pushObject App.Player.create
          name: "#{App.i18n.player} " + (i + 1)
    group.set 'players', players
    @get("items").pushObject group

