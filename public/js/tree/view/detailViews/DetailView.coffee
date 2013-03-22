App.DetailView = Em.View.extend
  classNames: ['detailView']

  didInsertElement: ->
    @_super()
    @$("rel[tooltip]").tooltip()

  init: ->
    @_super()
    @appendTo "body"