App.DetailView = Em.View.extend
  classNames: ['detailView hide']
  title: ""

  layout: Ember.Handlebars.compile """
    <i class="icon-remove closeButton"></i>
    <div class="detailContent">{{yield}}</div>
  """

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
    @$('.closeButton').click => @destroy()

  destroy: ->
    @$().fadeOut 'medium', =>
      $("#tournament").fadeIn 'slow', =>
    @_super()