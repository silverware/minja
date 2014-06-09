App.DetailView = Em.View.extend
  classNames: ['detailView']

  layout: Ember.Handlebars.compile """
    <span title="close" class="closeButton right noPrint">
      <i class="fa fa-times-circle"></i>
    </span>
    <div class="detailContent">{{yield}}</div>
  """

  didInsertElement: ->
    @_super()
    @$().hide()
    @$("rel[tooltip]").tooltip()
    App.BracketLineDrawer.hide()
    $(".tournament").fadeOut 'medium', =>
      $(".navbar-static-top").addClass "visible-lg"
      @$().fadeIn 'slow', =>
        @initExitableView()
      #@$(".detailContent").mCustomScrollbar scrollInertia: 10


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
      $(".navbar-static-top").removeClass "visible-lg"
      $(".tournament").fadeIn 'slow', =>
      App.BracketLineDrawer.show()

    @destroyElement()
    @_super()
