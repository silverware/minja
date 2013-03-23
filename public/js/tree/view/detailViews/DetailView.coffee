App.DetailView = Em.View.extend
  classNames: ['detailView']

  didInsertElement: ->
    @_super()
    @$("rel[tooltip]").tooltip()
    @initExitableView()

  init: ->
    @_super()
    @appendTo "body"

  initExitableView: ->
    $(document).keyup (e) =>
  	  if e.keyCode is 27
  	   @remove()

    exitButton = $ """<i class="icon-remove closeButton"></i>"""
    exitButton.click => @remove()
    @$().append exitButton


  filter: null