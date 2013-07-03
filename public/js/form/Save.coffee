class Save

  ajax: true
  url: null

  constructor: (args) ->
    $.extend @, args
    @init()
    @enableSaveButton()

  init: ->
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
            $.post @url, data, @_onSave
      else
        event.preventDefault()

  _onSave: (response) =>
    @form.find("button").removeAttr('disabled')
    @stopLoading()
    @showSuccess true
    @onSave response

  _onError: =>
    window.location.href = "/error"

  onSave: =>
    # Extension-Point

  startLoading: ->
    console.debug @form.find("button")
    @form.find("button").attr('disabled', 'disabled')
    $(".ajaxLoader").fadeIn("fast")

  stopLoading: ->
    @showSuccess false
    $(".ajaxLoader").hide()

  showSuccess: (show) ->
    if not show
      $(".successIcon").hide()
    else
      $(".successIcon").fadeIn("medium")
      setTimeout((-> $(".successIcon").fadeOut("fast")), 5000)

  enableSaveButton: =>
    setTimeout (=>@form.find("button").removeAttr "disabled"), 1000
