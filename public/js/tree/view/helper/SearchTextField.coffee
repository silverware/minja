App.SearchTextField = Ember.View.extend
  classNames: ['btn-group']
  template: Ember.Handlebars.compile """
    {{view Em.TextField classNames="form-control" valueBinding="view.value" placeholderBinding="view.placeholder" }}
    <i class="filter-input-close-button fa fa-times" {{action clearInput target="view"}}></i>
  """

  init: ->
    @_super()

  clearInput: ->
    @set 'value', null

  showCloseButton: (visiblie) ->
    if visiblie
      @$(".filter-input-close-button").show()
    else
      @$(".filter-input-close-button").hide()

  didInsertElement: ->
    @showCloseButton()

  onValueChanged: ( ->
    @showCloseButton @get 'value'
  ).observes("value")
