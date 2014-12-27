App.NumberFieldView = Ember.TextField.extend
  classNames: ['result-textfield']
  editable: true

  didInsertElement: ->
    @onEditableChange()

  onValueChanged: ( ->
    @set 'value', @onlyNumber @get 'value'
  ).observes("value")

  onEditableChange: (->
    @$().attr("disabled", not @get("editable"))
  ).observes("editable")

  onlyNumber: (input) ->
    console.debug input
    input.replace(/[^\d]/g, "") if input




