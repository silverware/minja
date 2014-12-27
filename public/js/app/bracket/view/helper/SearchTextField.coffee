App.SearchTextFieldView = Ember.View.extend
  classNames: ['btn-group', 'noPrint']
  template: Ember.Handlebars.compile """
    {{input classNames="form-control" value=view.value placeholder=view.placeholder}}
    <i class="filter-input-close-button fa fa-times" {{action 'clearInput' target="view"}}></i>
  """

  init: ->
    @_super()

  actions:
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
