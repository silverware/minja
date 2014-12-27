App.RoundItemView = Em.View.extend

  # To Override
  round: null

  didInsertElement: ->
    @$(".fa-search").tooltip
      title: App.i18n.bracket.detailView
    if App.editable
      @initDraggable()
      @draggable()
    if @get("round").get("isEditable")
      @$(".removeItem").tooltip
        title: App.i18n.remove
      @draggable()

  isDraggable: (->
    return (App.editable and @get('round.isNotStarted'))
  ).property('App.editable', 'round.isNotStarted')

  draggable: ->
    enable = @get('isDraggable')
    @$('.player').draggable if enable then "enable" else "disable"
    @$(".player").css "cursor", if enable then "move" else "default"

  onDraggableChanged: (->
    @draggable()
  ).observes('isDraggable')

  initDraggable: ->
    @$(".player").draggable
      containment: @get('parentView').$()
      helper: "clone"
      revert: "invalid"
      start: (e, {helper}) ->
        $(helper).addClass "ui-draggable-helper"
        tds = $(helper).find('td')
        if tds.length > 0
          $(tds[0]).empty()
          $(tds[1]).empty()
          $(tds[3]).empty()
          $(tds[4]).empty()
      stop: =>
        setTimeout (=> @draggable()), 20

    @$(".player").droppable
      drop: (event, ui) =>
        setTimeout (=> @draggable()), 20
        dragElement = $ ui.draggable[0]
        dropElement = $ event.target
        @get("round").swapPlayers(
          [parseInt(dragElement.find("#itemIndex")[0].textContent), parseInt(dragElement.find("#playerIndex")[0].textContent)],
          [parseInt(dropElement.find("#itemIndex")[0].textContent), parseInt(dropElement.find("#playerIndex")[0].textContent)])

