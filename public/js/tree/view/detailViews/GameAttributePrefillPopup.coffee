App.GameAttributePrefillPopup =
  games: []

  open: (@games) ->

    App.Popup.show
      title: App.i18n.prefillAttributes
      actions: [{closePopup: false, label: App.i18n.prefill, action: ->}]
      bodyContent: """
        hallo: asldkfj asdrjc asdlfkj Rcihasd flkdrj csdhf l
      """
