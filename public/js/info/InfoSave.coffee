define ["utils/Popup"], (Popup) ->

  class InfoSave extends Save
    
    i18n: null
    tournamentId: ""

    constructor: (args) ->
      super args
      @dateToggle()
      @initVenuePopup()
      $("#createPublicName").click @showPublicNamePopup

    dateToggle: ->
      @startDate = $("input[name=startDate]")
      @stopDate = $("input[name=stopDate]")
      @openStopdate = $("<span class='btn btn-link'>#{@i18n.stopTimeKnown}</span>")
      @deleteStopdate = $("<span class='btn btn-link'>#{@i18n.deleteStopTime}</span>")
      $("input[name=startTime]").after @openStopdate
      $("input[name=stopTime]").after @deleteStopdate

      $("input[name=startTime]").timepicker
        showMeridian: false
        defaultTime: false

      @startDate.datepicker
        format: "dd.mm.yyyy"
      
      if not @stopDate.val()
        @stopDate.closest(".control-group").hide()
      else
        @showStopDate false
      
      @deleteStopdate.click @hideStopDate
      @openStopdate.click @showStopDate

    hideStopDate: =>
      @stopDate.val ""
      $("input[name=stopTime]").val ""
      @stopDate.closest(".control-group").hide()
      @openStopdate.show()

    showStopDate: (setValue) =>
      if setValue
        @stopDate.val @startDate.val()
      @stopDate.closest(".control-group").show()
      @openStopdate.hide()
      $("input[name=stopTime]").timepicker
        showMeridian: false
        defaultTime: false
      @stopDate.datepicker
        format: "dd.mm.yyyy"

    showPublicNamePopup: =>
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
