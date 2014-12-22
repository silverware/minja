define ["utils/Popup", "datepicker"], (Popup) ->

  class InfoSave extends Save

    i18n: null
    tournamentId: ""

    constructor: (args) ->
      super args
      @dateToggle()
      @initVenuePopup()

    dateToggle: ->
      @startDate = $("#startDate")
      @stopDate = $("#stopDate")
      @stopDateInput = $("input[name=stopDate]")
      @openStopdate = $("<span class='btn btn-link'>#{@i18n.stopTimeKnown}</span>")
      @deleteStopdate = $("<span class='btn btn-link'>#{@i18n.deleteStopTime}</span>")
      $("#startTime").after @openStopdate
      $("#stopTime").after @deleteStopdate

      $("#startTime").datetimepicker
        format: "HH:mm"
        pickDate: false
        defaultTime: false

      @startDate.datetimepicker
        pickTime: false
        format: "DD.MM.YYYY"

      if not @stopDateInput.val()
        @stopDate.closest(".form-group").hide()
      else
        @showStopDate false

      @deleteStopdate.click @hideStopDate
      @openStopdate.click @showStopDate

    hideStopDate: =>
      @stopDateInput.val ""
      $("input[name=stopTime]").val ""
      @stopDate.closest(".form-group").hide()
      @openStopdate.show()

    showStopDate: (setValue) =>
      if setValue
        @stopDateInput.val @startDate.val()
      @stopDate.closest(".form-group").show()
      @openStopdate.hide()
      $("#stopTime").datetimepicker
        format: "HH:mm"
        pickDate: false
        defaultTime: false
      @stopDate.datetimepicker
        pickTime: false
        format: "DD.MM.YYYY"

    initVenuePopup: ->
      return
      @openVenuePopup = $("<span class='btn btn-link'>auf Karte eintragen</span>")
      $("input[name=venue]").after @openVenuePopup

    openPreview: ->
      $.get "/editor/preview", markdown: $('textarea[name=description]').val(), (html) =>
        Popup.show
          title: @i18n.preview
          cancelble: true
          bodyContent: html
