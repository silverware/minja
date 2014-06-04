define ["text!./chat_template.hbs"], (template) ->

  Em.Application.extend

    messages: []
    messagesUrl: ""
    messagesSaveUrl: ""
    editable: false
    i18n: null
    limit: 5
    rootElement: '#chat'

    init: ->
      @_super()
      @messagesUrl = "/#{@tournament_id}/messages"
      @messageSaveUrl = "/#{@tournament_id}/messages/create"
      @messageRemoveUrl = "/#{@tournament_id}/messages/remove"
      @initSave()
      @view.appendTo @rootElement
      @loadMessages()
      @messageOnFocusListener()

    initSave: ->
      new Save
        form: $("#chatForm")
        url: @messageSaveUrl
        onSave: =>
          @messages.clear()
          @loadMessages()
          $("input[name='message[author]']").val ""
          $("textarea[name='message[text]']").val ""

    loadMessages: ->
      $('#chatLoader').show()
      $.get @messagesUrl, first: @messages.get("length"), limit: @limit, (messages) =>
        $('#chatLoader').hide()
        if messages.length == 0 then $('#showMore').hide() else $('#showMore').show()
        for message in messages
          @messages.pushObject @Message.create message.value

    messageOnFocusListener: ->
      $("#message").focus ->
        $("#messageName").show()
        $("#publishButton").show()

    Message: Em.Object.extend
      _id: ""
      _rev: ""
      text: ""
      author: ""
      created_at: ""
      created_at_humanized: ""

      remove: ->
        $.post Chat.messageRemoveUrl, {id: @_id, rev: @_rev}
        Chat.messages.removeObject @


    view: Ember.View.create
      template: Ember.Handlebars.compile template
      didInsertElement: ->
        @$().hide().fadeIn 1000

