App.Popup =
  template: """
    <div class="modal fade" id="popup">
     <div class="modal-dialog">
     <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
        <h3 id="myModalLabel"></h3>
      </div>
      <div class="modal-body">
      </div>
      <div class="modal-footer">
      </div>
     </div>
     </div>
    </div>
  """
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
    $template = $ @template
    $template.find('#myModalLabel').html @title
    $("#appRoot").append $template

    if @cancelble
      @actions.push
        label: App.i18n.popup.cancel
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
    title = App.i18n.popup.question
    title = args.title if args.title
    confirmAction = {label: App.i18n.popup.yes, closePopup: true,action: => @onConfirm()}
    args.actions = [confirmAction, {label: App.i18n.popup.no, notBlue: true, closePopup: true, action: ->}]
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


