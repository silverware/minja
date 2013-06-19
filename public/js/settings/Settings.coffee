define ["utils/Popup"], (Popup) ->

  class Settings
    
    i18n: null
    tournamentId: ""

    constructor: (args) ->
      $("#createPublicName").click @showPublicNamePopup
      @initColorPicker()

    initColorPicker: ->
      $(".colorPicker").each (index, picker) ->
        console.debug picker
        $(picker).after """<span class="add-on"><i style="background-color: rgba(233,233,233,1)"></i></span>"""
        $(picker).colorpicker
          format: "rgba"
      

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


