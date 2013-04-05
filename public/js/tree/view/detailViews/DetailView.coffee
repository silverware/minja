App.DetailView = Em.View.extend
  classNames: ['detailView hide']

  layout: Ember.Handlebars.compile """
      <span title="close" class="carousel-control closeButton right">
        <i class="icon-remove"></i>
      </span>
    <div class="detailContent">{{yield}}</div>
  """

  didInsertElement: ->
    @_super()
    @$("rel[tooltip]").tooltip()
    @initExitableView()
    console.debug @
    $("#tournament").fadeOut 'medium', =>
      @$().fadeIn 'slow'

  init: ->
    @_super()
    @appendTo "body"

  initExitableView: ->
    #$(document).keydown (e) =>
    #  if e.keyCode is 27 then @destroy()
    @$('.closeButton').click => @destroy()

  destroy: ->
    @$().fadeOut 'medium', =>
      $("#tournament").fadeIn 'slow', =>
    
    @destroyElement()
    @_super()