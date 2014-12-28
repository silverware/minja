App.GroupRound = App.Round.extend
  _itemLabel: ""
  isGroupRound: null

  _letters: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  init: ->
    @_super()
    @_itemLabel = App.i18n.bracket.group
    @set 'isGroupRound', true

  addItem: ->
    if not @get('editable')
      App.Popup.showInfo
        bodyContent: App.i18n.bracket.roundItemNotAddable
      return
    
    group = App.Group.create
      name:"#{App.i18n.bracket.group} " + @_letters[@get('items.length')]
      _round: @
    
    # apply settings of previous group (playercount and qualifiercount)
    prevGroup = @get('items.lastObject')
    if prevGroup
      group.set "qualifierCount", prevGroup.get("qualifierCount")
      prevPlayersLength = prevGroup.get("players.length")

    playersCount = (prevPlayersLength - 1) or 3

    @get("items").pushObject group
    players = []
    for i in [0..playersCount]
      if @getFreeMembers()?[0]?
        players.pushObject @getFreeMembers()[0]
      else
        players.pushObject App.tournament.participants.getNewPlayer
          name: "#{App.i18n.bracket.player} " + (i + 1)
      group.set 'players', players

