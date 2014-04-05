define ["../lib/bootstrap-modules/spinner"], ->
  NumberSpinner = Ember.TextField.extend
    classNames: ['input-mini spinner-input']
    editable: true
    

    didInsertElement: ->
      @wrapper = $ """<div id="MySpinner" class="spinner"></div>"""
      @$().wrap @wrapper
      @$().after """
      <div class="spinner-buttons btn-group btn-group-vertical">
    <button type="button" class="btn spinner-up">
    <i class="icon-chevron-up"></i>
    </button>
    <button type="button" class="btn spinner-down">
    <i class="icon-chevron-down"></i>
    </button>
    </div>
      """
      @wrapper.spinner()
      @onEditableChange()

    onValueChanged: ( ->
      @set 'value', parseInt(@onlyNumber(@get('value')))
      console.debug @get "value"
    ).observes("value")

    onEditableChange: (->
      if @get("editable") then @get("wrapper").spinner("enable") else @get("wrapper").spinner("disable")
    ).observes("editable")

    onlyNumber: (input) ->
      input.replace(/[^\d]/g, "") if input
