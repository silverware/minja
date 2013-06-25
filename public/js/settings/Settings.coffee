define ["utils/Popup", "./ColorSelectionPopup"], (Popup, ColorSelection) ->

  class Settings

    i18n: null
    tournamentId: ""

    constructor: (args) ->
      $.extend @, args
      $("#createPublicName").click @showPublicNamePopup
      $("#selectTheme").click =>
        @colorSelection = ColorSelection.create
          i18n: @i18n
          onSelection: @fillColors

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

    fillColors: (colorTheme) =>
      console.debug "fill"
      for key, value of colorTheme
        if key is "name" then continue
        $("input[name='#{key}']").val value
      $("input[name='content']").closest("form").submit()

    savePublicName: ->
      $("#publicNameForm").submit()


