App.PlayerAttribute = Em.Object.extend
  name: ""
  type: "textfield"
  id: ""

  init: ->
    @_super()
    if not @id
      @set 'id', UniqueId.create()

  isCheckbox: (->
    @get("type") == "checkbox"
  ).property("type")

  isTextfield: (->
    @get("type") == "textfield"
  ).property("type")
