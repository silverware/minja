App.GameAttribute = Em.Object.extend
  name: ""
  type: ""
  id: ""

  init: ->
    @_super()
    @id = UniqueId.create() if not @id

  isCheckbox: (->
    @get("type") == "checkbox"
  ).property("type")
  isTextfield: (->
    @get("type") == "textfield"
  ).property("type")

  remove: ->
    App.Tournament.gameAttributes.removeObject @


App.attributeTypes = [
  Em.Object.create {type: "textfield", label: "Textfeld"}
  Em.Object.create {type: "checkbox", label: "Checkbox"}
]