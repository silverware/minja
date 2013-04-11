define ["text!./popup_template.hbs"], (template) ->

  popup =
    title: "Title"
    bodyUrl: null
    bodyContent: null
    actions: [{label: "Ok", closePopup: true, action: ->}]
    afterRendering: ->
    cancelble: false

    hide: ->
      $('#popup').modal('hide')

    show: (args) ->
      $.extend @, args

      if $("#popup").length > 0
        $("#popup").remove()

      template = template.replace "###title###", @title
      $("body").append template

      if @cancelble
        @actions.push 
          label: "Cancel"
          action: ->
          closePopup: true
          notBlue: true
      @_apendActionsToModal()

      ################ ADD CONTENT ######################
      if @bodyUrl?
        $('.modal-body').load "#{@bodyUrl}.template", @afterRendering
      else if @bodyContent?
        $(".modal-body").append @bodyContent
        @afterRendering()

      $("#popup").modal()

    showInfo: (args) ->
      args.title = """<i class="icon-ok"></i> Information"""
      @show args

    _apendActionsToModal: ->
      for action in @actions
        do (action) ->
          close = ""
          if action.closePopup
            close = "data-dismiss='modal'"
          if action.notBlue then style = "btn-inverse" else style = "btn-primary"
          button = $("""
          <button class="btn #{style}" #{close}>
            #{action.label}
          </button>""")
          button.click action.action
          $(".modal-footer").append button


