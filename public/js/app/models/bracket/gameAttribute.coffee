App.GameAttribute = Em.Object.extend
  name: ""
  type: ""
  id: ""

  init: ->
    @_super()
    @set('id', UniqueId.create()) if not @id

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

  isDate: (->
    @get("type") is "date"
  ).property("type")

  isTime: (->
    @get("type") is "time"
  ).property("type")

  remove: ->
    App.Popup.showQuestion
      title: App.i18n.bracket.deleteGameAttribute
      bodyContent: App.i18n.bracket.reallyDeleteGameAttribute
      onConfirm: =>
        App.tournament.bracket.gameAttributes.removeObject @




###
  Em.Object.create {type: "date", label: "Date"}
  Em.Object.create {type: "time", label: "Time"}
###
