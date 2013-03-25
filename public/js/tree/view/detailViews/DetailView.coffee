App.DetailView = Em.View.extend
  classNames: ['detailView hide']

  didInsertElement: ->
    @_super()
    @$("rel[tooltip]").tooltip()
    @initExitableView()
    $("#tournament").fadeOut 'slow'
    @$().show 'medium'

  init: ->
    @_super()
    @appendTo "body"

  initExitableView: ->
    $(document).keyup (e) =>
      if e.keyCode is 27
        @destroy()

    exitButton = $ """<i class="icon-remove closeButton"></i>"""
    exitButton.click => @destroy()
    @$().append exitButton

  destroy: ->
    @_super()
    $("#tournament").fadeIn 'medium'