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

  isNumber: (->
    @get("type") is "number"
  ).property("type")

  isResult: (->
    @get("type") is "result"
  ).property("type")

  remove: ->
    App.Popup.showQuestion
      bodyContent: App.i18n.reallyDeleteGameAttribute
      onConfirm: =>
        App.Tournament.gameAttributes.removeObject @


App.attributeTypes = [
  Em.Object.create {type: "checkbox", label: "Checkbox"}
  Em.Object.create {type: "textfield", label: "Textfeld"}
  #Em.Object.create {type: "result", label: "Result"}
  Em.Object.create {type: "number", label: "Number"}
]