App.GameAttribute = Em.Object.extend
  name: ""
  type: ""
  id: ""

  init: ->
    @_super()
    @id = UniqueId.create() if not @id

  isCheckbox: (->
    @get("type") is "checkbox"
  ).property("type")

  isTextfield: (->
    @get("type") is "textfield"
  ).property("type")

  remove: ->
    App.Tournament.gameAttributes.removeObject @


App.attributeTypes = [
  Em.Object.create {type: "checkbox", label: "Checkbox"}
  Em.Object.create {type: "textfield", label: "Textfeld"}
]