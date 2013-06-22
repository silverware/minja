define ["utils/Popup", "./ColorSelectionPopup"], (Popup, ColorSelection) ->

  class Settings

    i18n: null
    tournamentId: ""

    constructor: (args) ->
      $.extend @, args
      $("#createPublicName").click @showPublicNamePopup
      $("#selectTheme").click =>
        ColorSelection.create
          i18n: @i18n

    showPublicNamePopup: =>
      console.debug @
      popup = Popup.show
        title: @i18n.publicName
        actions: [{label: @i18n.save, action: @savePublicName, closePopup: false}]
        cancelble: true
        bodyUrl: "/tournament/info/public_name_popup"
        afterRendering: =>
          new Save
            url: "/#{@tournamentId}/savePublicName"
            form: $("#publicNameForm")
            onSave: ->
              $("#publicNameValue").html $("#inputPublicName").val().toLowerCase()
              popup.hide()

    savePublicName: ->
      $("#publicNameForm").submit()


