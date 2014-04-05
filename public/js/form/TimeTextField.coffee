define ->
  
  Ember.TextField.extend
    classNames: ['m']
    editable: true

    didInsertElement: ->
      @onEditableChange()
      @$().datepicker
        format: 'dd.mm.yyyy'

    onEditableChange: (->
      @$().attr("disabled", not @get("editable"))
    ).observes("editable")

