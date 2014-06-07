App.RoundItemView = Em.View.extend

  # To Override
  round: null

  onEditableChanged: (->
    @draggable @get("round").get("isEditable")
  ).observes("round.isEditable")

  didInsertElement: ->
    @$(".fa-search").tooltip
      title: App.i18n.detailView
    if App.editable
      @initDraggable()
      @draggable false
    if @get("round").get("isEditable")
      @$(".removeItem").tooltip
        title: App.i18n.remove
      @draggable true

  draggable: (enable) ->
    @$('.player').draggable if enable then "enable" else "disable"
    @$(".player").css "cursor", if enable then "move" else "default"

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
          $(tds[2]).empty()
          $(tds[3]).empty()
          console.debug tds
      stop: =>
        setTimeout (=> @draggable true), 20

    @$(".player").droppable
      drop: (event, ui) =>
        setTimeout (=> @draggable true), 20
        dragElement = $ ui.draggable[0]
        dropElement = $ event.target
        @get("round").swapPlayers(
          [parseInt(dragElement.find("#itemIndex")[0].textContent), parseInt(dragElement.find("#playerIndex")[0].textContent)],
          [parseInt(dropElement.find("#itemIndex")[0].textContent), parseInt(dropElement.find("#playerIndex")[0].textContent)])

