define ["./DynamicTextField"], (DynamicTextField) ->
  DynamicVisibleTextField = DynamicTextField.extend

    didInsertElement: ->
      @_super()
      @$().removeClass("dynamicTextField")