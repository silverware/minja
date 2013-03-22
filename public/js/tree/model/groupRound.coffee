App.GroupRound = App.Round.extend
  _itemLabel: ""
  isGroupRound: true

  letters: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  init: ->
    @_super()
    @_itemLabel = App.i18n.group

  addItem: ->
    group = App.Group.create
      name:"#{App.i18n.group} " + @letters[@items.content.length]
      _round: @
    players = []
    for i in [0..3]
      if @getFreeMembers()?[i]?
        players.pushObject @getFreeMembers()[i]
      else
        players.pushObject App.Player.create
          name: "#{App.i18n.player} " + (i + 1)
    group.players.set "content", players 
    @get("items").pushObject group

