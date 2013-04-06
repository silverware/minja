App.RoundItemView = Em.View.extend

  # To Override
  round: null
  
  onEditableChanged: (->
    if not @get("round").get("isEditable")
      @$('.player').draggable "disable"
    else
      if @get("round").isGroupRound
        @initDraggable()
      else  
        @$('.player').draggable "enable"
  ).observes("round.isEditable")
  
  didInsertElement: ->
    @$(".icon-search").tooltip
      title: App.i18n.detailView
    if @get("round").get("isEditable")
      @$(".removeItem").tooltip
        title: App.i18n.remove
      @initDraggable()
  
  initDraggable: ->
    @$(".player").draggable
      containment: @get('parentView').$()
      helper: "clone"
      revert: 'invalid'

    @$(".player").droppable
      drop: (event, ui) =>
        dragElement = $ ui.draggable[0]
        dropElement = $ event.target
        @get("round").swapPlayers(
          [parseInt(dragElement.find("#itemIndex")[0].textContent), parseInt(dragElement.find("#playerIndex")[0].textContent)],
          [parseInt(dropElement.find("#itemIndex")[0].textContent), parseInt(dropElement.find("#playerIndex")[0].textContent)])
          