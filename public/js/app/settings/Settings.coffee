define ["utils/Popup", "./ColorSelectionPopup"], (Popup, ColorSelection) ->

  class Settings

    i18n: null
    tournamentId: ""

    constructor: (args) ->
      $.extend @, args
      $("#selectTheme").click =>
        @colorSelection = ColorSelection.create
          i18n: @i18n
          onSelection: @fillColors

    fillColors: (colorTheme) =>
      console.debug "fill"
      for key, value of colorTheme
        if key is "name" then continue
        $("input[name='#{key}']").val value
      $("input[name='content']").closest("form").submit()

