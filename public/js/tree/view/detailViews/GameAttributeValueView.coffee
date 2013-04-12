App.GameAttributeValueView = Ember.View.extend
  template: Ember.Handlebars.compile """
    {{#if view.attribute.isCheckbox}}
      {{#if App.editable}}
        {{view Ember.Checkbox checkedBinding="view.gameValue"}}
      {{else}}
        {{#if view.gameValue}}
          <i class="icon-ok" style="color: #DA5919" />
        {{/if}}
      {{/if}}
    {{else}}
      {{#if view.attribute.isResult}}
        {{#if App.editable}}
          {{view App.NumberField valueBinding="view.resultGameValue1"}}
          :
          {{view App.NumberField valueBinding="view.resultGameValue2"}}
        {{else}}
          {{view.gameValue}}
        {{/if}}
      {{else}}
        {{#if view.attribute.isNumber}}
          {{#if App.editable}}
            {{view App.NumberField valueBinding="view.gameValue"}}
          {{else}}
            {{view.gameValue}}
          {{/if}}
        {{else}}

          {{#if view.attribute.isTextfield}}
            {{#if App.editable}}
              {{view App.DynamicTypeAheadTextField attributeBinding="attribute" valueBinding="view.gameValue"}}
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
  space: " "

  gameValue: ((key, value) ->
    # GETTER
    if arguments.length == 1
      return @get("game")[@get("attribute.id")]
    # SETTER
    else
      @get("game").set @get("attribute.id"), value
  ).property("member", "attribute.name")

  resultGameValue1: ((key, value) ->
    currentValue = @get("game")[@get("attribute.id")]
    currentValue = "" if not currentValue
    splitted = currentValue.split ":"
    if splitted.length is not 2
      currentValue = ":"
      splitted = currentValue.split ":"
    # GETTER
    if arguments.length == 1
      return splitted[0]
    # SETTER
    else
      @get("game").set @get("attribute.id"), "#{value}:#{splitted[1]}"
  ).property("member", "attribute.name")


  resultGameValue2: ((key, value) ->
    currentValue = @get("game")[@get("attribute.id")]
    currentValue = "" if not currentValue
    splitted = currentValue.split ":"
    if splitted.length is not 2
      currentValue = ":"
      splitted = currentValue.split ":"
    # GETTER
    if arguments.length == 1
      return splitted[1]
    # SETTER
    else
      @get("game").set @get("attribute.id"), "#{value}:#{splitted[0]}"
  ).property("member", "attribute.name")