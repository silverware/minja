App.GameAttribute = Em.Object.extend
  name: ""
  type: "textfield"
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
  Em.Object.create {id: "textfield", label: "Textfeld"}
  Em.Object.create {id: "checkbox", label: "Checkbox"}
  Em.Object.create {id: "datetextbox", label: "Datumsfeld"}
]