App.GameAttributeValueView = Ember.View.extend
  template: Ember.Handlebars.compile """
    {{#if view.attribute.isCheckbox}}
      {{#if App.editable}}
        {{view Ember.Checkbox checked=view.gameValue}}
      {{else}}
        {{#if view.gameValue}}
          <i class="fa fa-check" />
        {{/if}}
      {{/if}}
    {{else}}
      {{#if view.attribute.isResult}}
        {{#if App.editable}}
          <div class="result-container">
            {{view 'numberField' classNames="form-control" value=view.resultGameValue1}}
          </div>
          <div class="result-container">
            {{view 'numberField' classNames="form-control" value=view.resultGameValue2}}
          </div>
        {{else}}
          {{view.gameValue}}
        {{/if}}
      {{else}}
        {{#if view.attribute.isNumber}}
          {{#if App.editable}}
            {{view 'numberField' classNames="form-control xs" value=view.gameValue}}
          {{else}}
            {{view.gameValue}}
          {{/if}}
        {{else}}
          {{#if view.attribute.isTextfield}}
            {{#if App.editable}}
              {{view 'dynamicTypeAheadTextField' classNames="form-control" attribute=attribute value=view.gameValue}}
            {{else}}
              {{view.gameValue}}
            {{/if}}
          {{/if}}
        {{/if}}
      {{/if}}
    {{/if}}
  """

  tagName: 'td'
  game: null
  attribute: null
  classNames: ['center']

  didInsertElement: ->
    if @get("attribute.isDate")
      @$(".dateTextBox").datepicker()
    if @get("attribute.isTime")
      @$(".timeTextBox").timepicker()

  gameValue: ((key, value) ->
    # SETTER
    if arguments.length > 1
      @get("game").set @get("attribute.id"), value
    # SETTER
    return @get("game").get(@get("attribute.id"))
  ).property("game", "attribute.name")

  resultGameValue1: ((key, value) ->
    splitted = @resultSplitted()
    # SETTER
    if arguments.length > 1
      value = "" if not value?
      @get("game").set @get("attribute.id"), "#{value}:#{splitted[1]}"
    # GETTER
    return splitted[0]
  ).property("resultGameValue2", "game._playersSwapped")

  resultGameValue2: ((key, value) ->
    splitted = @resultSplitted()
    # SETTER
    if arguments.length > 1
      value = "" if not value?
      @get("game").set @get("attribute.id"), "#{splitted[0]}:#{value}"
    # GETTER
    return splitted[1]
  ).property('resultGameValue1', "game._playersSwapped")

  resultSplitted: ->
    currentValue = @get("game").get(@get("attribute.id"))
    currentValue = "" if not currentValue
    splitted = currentValue.split ":"
    if splitted.length isnt 2
      splitted = ['', '']
    splitted
