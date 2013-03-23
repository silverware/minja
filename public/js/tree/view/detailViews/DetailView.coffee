App.DetailView = Em.View.extend
  classNames: ['detailView']
  gameFilter: null

  didInsertElement: ->
    @_super()
    @$("rel[tooltip]").tooltip()
    @initExitableView()

  init: ->
    @_super()
    @set "gameFilter",
      fastSearch: null
      attributes: []
    @appendTo "body"

  initExitableView: ->
    $(document).keyup (e) =>
      if e.keyCode is 27
       @remove()

    exitButton = $ """<i class="icon-remove closeButton"></i>"""
    exitButton.click => @remove()
    @$().append exitButton

  subStringContained: (s, sub) ->
    s.toLowerCase().indexOf(sub.toLowerCase()) isnt -1

  filteredGames: (->
    s = @get("gameFilter.fastSearch")
    if s then s = s.split ' '
    filtered = @get("group.games").filter (game) =>
      if not s then return true
      s.every (substring) =>
        if not substring then return true
        false or @subStringContained game.player2.name, substring or @subStringContained game.player1.name, substring
  ).property("gameFilter", "group.games.@each")
