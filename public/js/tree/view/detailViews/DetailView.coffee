App.DetailView = Em.View.extend
  classNames: ['detailView hide']

  layout: Ember.Handlebars.compile """
    <span title="close" class="carousel-control closeButton right noPrint">
      <i class="icon-remove"></i>
    </span>
    <div class="detailContent">{{yield}}</div>
  """

  didInsertElement: ->
    @_super()
    @$("rel[tooltip]").tooltip()
    $(".tournament").fadeOut 'medium', =>
      @$().fadeIn 'slow', =>
        @initExitableView()
      @$(".detailContent").mCustomScrollbar
        scrollInertia: 10


  init: ->
    @_super()
    @appendTo "body"

  initExitableView: ->
    $(document).bind "keydown", (e) =>
      if e.keyCode is 27 and @
        e.preventDefault()
        $(document).unbind "keydown"
        @destroy()

    @$('.closeButton').click => @destroy()

  destroy: ->
    @$().fadeOut 'medium', =>
      $(".tournament").fadeIn 'slow', =>

    @destroyElement()
    @_super()
