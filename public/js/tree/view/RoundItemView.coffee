App.RoundItemView = Em.View.extend

  # To Override
  round: null
  
  onEditableChanged: (->
    @draggable @get("round").get("isEditable")
  ).observes("round.isEditable")
  
  didInsertElement: ->
    @$(".icon-search").tooltip
      title: App.i18n.detailView
    @initDraggable()
    if @get("round").get("isEditable")
      @$(".removeItem").tooltip
        title: App.i18n.remove
    @draggable @get("round").get("isEditable")

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
          