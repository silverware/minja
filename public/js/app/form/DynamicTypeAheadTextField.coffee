App.DynamicTypeAheadTextFieldView = App.DynamicTextFieldView.extend

  # name: String
  #   Name der Klasse, zu der alle Inputelements gesucht werden,
  #   und deren Values ausgelesen werden.
  name: null

  didInsertElement: ->
    @_super()
    @$().addClass(@name)

  focusIn: ->
    @_super()
    values = (input.value for input in $(".#{@name}"))
    @$().typeahead
      source: _.uniq values
