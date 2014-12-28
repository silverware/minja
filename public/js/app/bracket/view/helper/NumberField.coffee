App.NumberFieldView = Ember.TextField.extend
  classNames: ['result-textfield']
  editable: true
  type: 'number'

  didInsertElement: ->
    @onEditableChange()

  onValueChanged: ( ->
    # @set 'value', @onlyNumber @get 'value'
  ).observes("value")

  onEditableChange: (->
    @$().attr("disabled", not @get("editable"))
  ).observes("editable")

  onlyNumber: (input) ->
    if typeof input is 'number'
      return input
    if input
      return input.replace(/[^\d]/g, "")
    input




