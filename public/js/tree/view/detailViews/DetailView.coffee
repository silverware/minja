App.DetailView = Em.View.extend
  classNames: ['detailView hide']

  didInsertElement: ->
    @_super()
    @$("rel[tooltip]").tooltip()
    @initExitableView()
    $("#tournament").fadeOut 'medium', =>
      @$().fadeIn 'slow'

  init: ->
    @_super()
    @appendTo "body"

  initExitableView: ->
    #$(document).keyup (e) =>
    #  if e.keyCode is 27 then @destroy()
    exitButton = $ """<i class="icon-remove closeButton"></i>"""
    exitButton.click => @destroy()
    @$().append exitButton

  destroy: ->
    @$().fadeOut 'medium', =>
      $("#tournament").fadeIn 'slow', =>
        @_super()