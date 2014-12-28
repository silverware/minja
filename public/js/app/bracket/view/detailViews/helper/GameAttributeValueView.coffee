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
    # GETTER
    if arguments.length == 1
      return @get("game")[@get("attribute.id")]
    # SETTER
    else
      @get("game").set @get("attribute.id"), value
  ).property("member", "attribute.name")

  resultGameValue1: ((key, value) ->
    splitted = @resultSplitted()
    # GETTER
    if arguments.length == 1
      return splitted[0]
    # SETTER
    else
      value = "" if not value?
      @get("game").set @get("attribute.id"), "#{value}:#{splitted[1]}"
  ).property("member", "attribute.name", "game._playersSwapped")


  resultGameValue2: ((key, value) ->
    splitted = @resultSplitted()
    # GETTER
    if arguments.length == 1
      return splitted[1]
    # SETTER
    else
      value = "" if not value?
      @get("game").set @get("attribute.id"), "#{splitted[0]}:#{value}"
  ).property("member", "attribute.name", "game._playersSwapped")

  resultSplitted: ->
    currentValue = @get("game")[@get("attribute.id")]
    currentValue = "" if not currentValue
    splitted = currentValue.split ":"
    if splitted.length is not 2
      currentValue = ":"
      splitted = currentValue.split ":"
    splitted
