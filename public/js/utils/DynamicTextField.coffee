define ->
  
  DynamicTextField = Ember.TextField.extend
    classNames: ['s', 'dynamicTextField']
    minWidth: 20
    editable: true

    onValueChanged: ( ->
      @updateWidth()
    ).observes("value")

    didInsertElement: ->
      @updateWidth()
      @onEditableChange()

    onEditableChange: (->
      @$().attr("disabled", not @get("editable"))
    ).observes("editable")

    updateWidth: () ->
      sensor = $('<label>' + @get("value") + '</label>').css
        margin: 0
        padding: 0
        display: "inline-block"
      $("body").append sensor
      width = sensor.width() + 6
      sensor.remove()
      @$().width Math.max(@minWidth, width)  + "px"

