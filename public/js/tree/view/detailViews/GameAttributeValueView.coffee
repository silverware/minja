App.GameAttributeValueView = Ember.View.extend
  template: Ember.Handlebars.compile """
    {{#if view.attribute.isCheckbox}}
      {{view.space}}
      {{#if App.editable}}
        {{view Ember.Checkbox checkedBinding="view.gameValue"}}
      {{else}}
        {{#if view.gameValue}}
          <i class="icon-ok" style="color: #DA5919" />
        {{/if}}
      {{/if}}
    {{/if}}

    {{#if view.attribute.isResult}}
      {{view.space}}
      {{#if App.editable}}
        {{view App.NumberField valueBinding="view.resultGameValue1"}}
        :
        {{view App.NumberField valueBinding="view.resultGameValue2"}}
      {{else}}
        {{view.gameValue}}
      {{/if}}
    {{/if}}

   {{#if view.attribute.isNumber}}
      {{view.space}}
      {{#if App.editable}}
        {{view App.NumberField valueBinding="view.gameValue"}}
      {{else}}
        {{view.gameValue}}
      {{/if}}
    {{/if}}

    {{#if view.attribute.isTextfield}}
      {{#if App.editable}}
        {{view App.DynamicTypeAheadTextField attributeBinding="attribute" valueBinding="view.gameValue"}}
      {{else}}
        {{view.gameValue}}
      {{/if}}
    {{/if}}
  """

  tagName: 'td'
  game: null
  attribute: null
  space: ""

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

    # GETTER
    if arguments.length == 1
      return @get("game")[@get("attribute.id")]
    # SETTER
    else
      @get("game").set @get("attribute.id"), value
  ).property("member", "attribute.name")


  resultGameValue2: ((key, value) ->
    # GETTER
    if arguments.length == 1
      return @get("game")[@get("attribute").id]
    # SETTER
    else
      @get("game").set @get("attribute").id, value
  ).property("member", "attribute.name")