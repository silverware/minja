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
    for detailView in App.openDetailViews
      detailView.hide()
    App.openDetailViews.pushObject @
    @appendTo "body"

  initExitableView: ->
    $(document).bind "keydown", (e) =>
      if e.keyCode is 27 and @
        e.preventDefault()
        if @ is _.last App.openDetailViews
          $(document).unbind "keydown"
          @destroy()

    @$('.closeButton').click => @destroy()

  hide: ->
    @$().hide()

  show: ->
    @$().fadeIn 'medium'

  destroy: ->
    App.openDetailViews.removeObject @
    lastDetailView = _.last App.openDetailViews

    @$().fadeOut 'medium', =>
      if not lastDetailView
        $(".navbar-static-top").removeClass "visible-lg"
        $(".tournament").fadeIn 'slow', =>
        App.BracketLineDrawer.show()
      else
        lastDetailView.show()

    @destroyElement()
    @_super()
