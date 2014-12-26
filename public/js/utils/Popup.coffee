define ["text!./popup_template.hbs", "json!/i18n/popup"], (template, i18n) ->

  popup =
    hide: ->
      $('#popup').modal('hide')

    init: (args) ->
      @title = ""
      @bodyUrl = null
      @bodyContent = null
      @actions = [{label: "Ok", closePopup: true, action: ->}]
      @afterRendering = ->
      @onConfirm = ->
      @cancelble = false
      @size = "md"
      @[name] = method for name, method of args

    show: (args) ->
      @init args
      if $("#popup").length > 0
        $("#popup").remove()
      $template = $ template
      $template.find('#myModalLabel').html @title
      $("#appRoot").append $template

      if @cancelble
        @actions.push
          label: i18n.cancel
          action: ->
          closePopup: true
          notBlue: true
      @_apendActionsToModal()


      ################ SIZE ######################
      dialog = $template.find ".modal-dialog"
      dialog.addClass "modal-" + @size

      ################ ADD CONTENT ######################
      if @bodyUrl?
        $('.modal-body').load "#{@bodyUrl}.template", => @afterRendering($("#popup"))
      else if @bodyContent?
        if typeof @bodyContent is "string"
          $(".modal-body").append @bodyContent
        else
          @bodyContent.appendTo ".modal-body"
        @afterRendering($("#popup"))

      $("#popup").modal()

    showInfo: (args) ->
      title = "Information"
      title = args.title if args.title
      args.title = """<i class="fa fa-info-circle"></i> #{title}"""
      @show args

    showQuestion: (args) ->
      title = i18n.question
      title = args.title if args.title
      confirmAction = {label: i18n.yes, closePopup: true,action: => @onConfirm()}
      args.actions = [confirmAction, {label: i18n.no, notBlue: true, closePopup: true, action: ->}]
      args.title = """<i class="fa fa-question-circle"></i> #{title}"""
      @show args


    _apendActionsToModal: ->
      for action in @actions
        do (action) ->
          close = ""
          if action.closePopup
            close = "data-dismiss='modal'"
          if action.notBlue then style = "btn-inverse" else style = "btn-inverse"
          button = $("""
          <button class="btn #{style}" #{close}>
            #{action.label}
          </button>""")
          button.click action.action
          $(".modal-footer").append button


