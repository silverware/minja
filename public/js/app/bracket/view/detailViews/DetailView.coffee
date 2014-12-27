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

    container = @getContainer()

    container.fadeOut 'medium', =>
      $(".navbar-static-top").addClass "visible-lg"
      @$().fadeIn 'medium', =>
        @initExitableView()
      #@$(".detailContent").mCustomScrollbar scrollInertia: 10


  init: ->
    @_super()
    for detailView in App.openDetailViews
      detailView.hide()
    App.openDetailViews.pushObject @
    @appendTo '#appRoot'

  initExitableView: ->
    $(document).bind "keydown." + @get('elementId'), (e) =>
      if e.keyCode is 27 and @
        e.preventDefault()
        if @ is _.last App.openDetailViews
          $(document).unbind "keydown." + @get('elementId')
          @destroy()

    @$('.closeButton').click => @destroy()

  hide: ->
    @$().hide()

  show: ->
    @$().fadeIn 'medium'

  getContainer: ->
    if $(".tournament").exists()
      return $(".tournament")
    if $("#players-container").exists()
      return $("#players-container")
    throw 'no container found'

  destroy: ->
    App.openDetailViews.removeObject @
    lastDetailView = _.last App.openDetailViews

    if lastDetailView
      lastDetailView.$().show()
    @$().fadeOut 'medium', =>
      if not lastDetailView
        $(".navbar-static-top").removeClass "visible-lg"
        @getContainer().fadeIn 'slow', =>
        App.BracketLineDrawer.show()

    @destroyElement()
    @_super()
