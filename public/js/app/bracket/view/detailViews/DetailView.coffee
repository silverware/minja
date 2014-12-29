App.DetailView = Em.View.extend
  classNameBindings: ['controller.isHidden:hide']
  classNames: ['detailView']

  layout: Ember.Handlebars.compile """
    <span title="close" class="closeButton right noPrint" {{action 'closeDetailView'}}>
      <i class="fa fa-times-circle"></i>
    </span>
    <div class="detailContent">{{yield}}</div>
  """

  didInsertElement: ->
    @_super()
    # @$().hide()
    # @$("rel[tooltip]").tooltip()
    # App.BracketLineDrawer.hide()

    # container = @getContainer()

    # container.fadeOut 'medium', =>
    #   $(".navbar-static-top").addClass "visible-lg"
    #   @$().fadeIn 'medium', =>
    #     @initExitableView()
      #@$(".detailContent").mCustomScrollbar scrollInertia: 10

    # @$('.closeButton').click =>
    #   @send 'close'
    # @destroy()
  actions:
    close: ->
      console.debug 'close detail view'
      @send 'closeDetailView'

  hide: ->
    @$().hide()

  show: ->
    @$().fadeIn 'medium'


  destroy: ->
    # App.openDetailViews.removeObject @
    # lastDetailView = _.last App.openDetailViews

    # if lastDetailView
    #   lastDetailView.$().show()
    # @$().fadeOut 'medium', =>
    #   if not lastDetailView
    #     $(".navbar-static-top").removeClass "visible-lg"
    #     @getContainer().fadeIn 'slow', =>
    #     App.BracketLineDrawer.show()

    @destroyElement()
    @_super()

