App.templates.chat = """
  <div class="container container-normal">
    <h1>{{i18n.chat.messageStream}}</h1>
      <fieldset>
        <legend>{{i18n.chat.message}}</legend>
        <form class="form-horizontal" id="chat-form" role="form">
          {{#unless tournament.isOwner}}
            {{#form-group label='Name' name="message[author]" formControl="col-md-4"}}
              {{input id="message-name" name="message[author]" placeholder="Name" class="form-control required"}}
            {{/form-group}}
          {{/unless}}
          {{#form-group label='Text' name="message[text]"}}
            {{textarea id="message" rows="1" name="message[text]" placeholder=i18n.chat.message class="form-control required"}}
          {{/form-group}}
          {{save-button label=i18n.chat.publish}}
        </form>
      </fieldset>
      <br 7>
      <br 7>
    {{#each message in sortedMessages}}
      <div class="row">
        <div class="col-md-8">
          {{message.author}}
          <small>&nbsp;&nbsp;{{message.created_at_humanized}}</small>
        </div>
        <div class="col-md-4">
          {{#if tournament.isOwner}}
             <button class="btn btn-link pull-right" style="padding: 0" {{action "removeMessage" message}}><i class="fa fa-trash-o"></i>{{i18n.chat.delete}}</button>
          {{/if}}
        </div>
      </div>
      <pre style="margin-bottom: 20px">{{message.text}}</pre>
    {{/each}}
  </div>
"""

App.ChatView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.chat

  didInsertElement: ->
    @_super()
    new Save
      form: $("#chat-form")
      url: @get('controller.messageCreateUrl')
      onSave: (message) =>
        App.tournament.messages.pushObject App.Message.create message
        @$("input[name='message[author]']").val ""
        @$("textarea[name='message[text]']").val ""

