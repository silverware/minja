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

  gameValue: ((key, value) ->
    # GETTER
    if arguments.length == 1
      return @get("game")[@get("attribute").id]
    # SETTER
    else
      @get("game").set @get("attribute").id, value
  ).property("member", "attribute.name")