window.saves = []
window.Save = class Save

  ajax: true
  url: null

  constructor: (args) ->
    $.extend @, args
    @init()
    @enableSaveButton()

  init: ->
    console.debug "saves: " + saves
    @form.submit (event) =>
      @formValidator = new FormValidator @form

      if @formValidator.validate()
        if @ajax
          @startLoading()
          event.preventDefault()

          @url = @form.attr 'action' if not @url

          if typeof @data == 'function'
            data = @data()
            console.debug data
            $.ajax
              type: "POST"
              url: @url
              data: JSON.stringify(data)
              contentType: "application/json; charset=utf-8"
              success: @_onSave
              error: @_onError
          else
            data = @form.serialize()
            xhr = $.post @url, data, @_onSave
            xhr.fail @_onError
      else
        event.preventDefault()

  _onSave: (response) =>
    @form.find("button").removeAttr('disabled')
    @stopLoading()
    @showSuccess true
    @onSave response

  _onError: =>
    # window.location.href = "/error"
    @form.find("button").removeAttr('disabled')
    @stopLoading()


  onSave: =>
    # Extension-Point

  startLoading: ->
    @form.find("button").attr('disabled', 'disabled')
    @form.find(".ajaxLoader").fadeIn("fast")

  stopLoading: ->
    @showSuccess false
    @form.find(".ajaxLoader").hide()

  showSuccess: (show) ->
    if not show
      @form.find(".successIcon").hide()
    else
      @form.find(".successIcon").fadeIn("medium")
      setTimeout((=> @form.find(".successIcon").fadeOut("fast")), 5000)

  enableSaveButton: =>
    setTimeout (=> @form.find("button").removeAttr "disabled"), 1000
