define ->
  class GallerySave extends Save

    init: ->
      @form.submit (event) =>
        @startLoading()
        event.preventDefault()

        data = @data()
        $.ajax
          type: "POST"
          data: data
          contentType: false
          processData: false
          success: @_onSave
          error: @_onError
