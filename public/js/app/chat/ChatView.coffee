App.templates.chat = """
  <div class="container container-normal">
    <h1>{{i18n.chat.messageStream}}</h1>
    <form class="form-horizontal" id="chat-form" role="form">
      {{#unless tournament.isOwner}}
        <input type="text" id="messageName" class="form-control required hide" placeholder="Name" name="message[author]" />
      {{/unless}}
      <div class="form-group">
        <textarea id="message" rows="1" class="required form-control" placeholder="{{unbound i18n.chat.message}}" name="message[text]"></textarea>
      </div>
      <div class="form-group">
        <button type="submit" id="publish-button" class="btn btn-inverse hide">{{i18n.chat.publish}}</button>
      </div>
    </form>
    {{#each message in messages}}
      <div class="row">
        <div class="col-md-8">
          {{message.author}}
          <small>&nbsp;&nbsp;{{message.created_at_humanized}}</small>
        </div>
        <div class="col-md-4">
          {{#if editable}}
             <button class="btn btn-link pull-right" style="padding: 0" {{action "remove" target="message"}}><i class="fa fa-trash-o"></i>{{i18n.chat.delete}}</button>
          {{/if}}
        </div>
      </div>
      <pre style="margin-bottom: 20px">{{message.text}}</pre>
    {{/each}}

    <center><i id="chatLoader" class="fa fa-spinner fa-spin"></i></center>
    <button id="showMore" class="hide btn btn-inverse" {{action "loadMessages"}}>
      {{i18n.chat.showMore}}
    </button>
  </div>
"""

App.ChatView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.chat

  didInsertElement: ->
    @_super()

