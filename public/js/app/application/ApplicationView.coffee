Chat.ApplicationView = Em.View.extend
  classNames: ['chat']
  defaultTemplate: Ember.Handlebars.compile """
    <nav class="nav-0">
      <ul>
        {{#link-to 'index' tagName='li'}}
          <i class="icon-home"></i>
          {{#if view.isExpanded}}Home{{/if}}
        {{/link-to}}
      </ul>

      {{#if Chat.isAuthenticated}}
        <h5 {{bind-attr class="view.isExpanded::hide"}}>channels</h5>
        <ul>
          {{#each chan in Chat.chans}}
            {{#link-to 'chan' chan.name tagName='li' data-original-title='ashdfl'}}<img src="/img/dummy.png" />
              {{#if view.isExpanded}}
              {{chan.name}}{{#if chan.newMessages}}<span class="new-messages">{{chan.newMessages}}</span>{{/if}}
              <i {{action part target="chan"}} style="float: right; padding-top: 12px" title="leave chan" class="actions icon-reply"></i>
              {{/if}}
            {{/link-to}}
          {{/each}}
        </ul>

        {{#if Chat.privateChannels}}
        <h5 {{bind-attr class="view.isExpanded::hide"}}>private channels</h5>
        <ul>
          {{#each channel in Chat.privateChannels}}
            <li {{action "open" target="channel"}}><img src="/img/dummy.png" />
              {{channel.username}}
              {{#if channel.newMessages}}<span class="new-messages">{{channel.newMessages}}</span>{{/if}}
            </li>
          {{/each}}
        </ul>
        {{/if}}

        {{#if Chat.videoChat}}
        <h5 {{bind-attr class="view.isExpanded::hide"}}>video chat</h5>
        <ul>
          {{#link-to 'video' Chat.videoChat.username tagName='li'}}
            <img src="/img/dummy.png" />
            {{Chat.videoChat.username}}
          {{/link-to}}
        </ul>
        {{/if}}
      {{/if}}

      <div class="bottom-nav">
        {{#if Chat.isAuthenticated}}
          <h5 {{bind-attr class="view.isExpanded::hide"}}>{{Chat.ticket.username}}</h5>
          <ul>
            {{#unless Chat.isGuest}}
              {{#link-to 'profile' tagName='li'}}
                <i class="icon-edit"></i>
                {{#if view.isExpanded}}Edit Profile{{/if}}
              {{/link-to}}
            {{/unless}}
            <li {{action logout target="Chat"}}>
              <i class="icon-edit"></i>
              {{#if view.isExpanded}}Logout{{/if}}
            </li>
          </ul>
       {{else}}
         <ul>
            {{#link-to 'login' tagName='li'}}
              <i class="icon-edit"></i>
                {{#if view.isExpanded}}Login{{/if}}
            {{/link-to}}
            {{#link-to 'signup' tagName='li'}}
              <i class="icon-edit"></i>
              {{#if view.isExpanded}}Signup{{/if}}
            {{/link-to}}
            <li {{action toggleExpansion target="view"}}>expand</li>
         </ul>
       {{/if}}
       </div>

      </nav>

      {{outlet sidebar}}

      <div id="queryStreams">
        {{#each stream in Chat.queryStreams}}
          {{#if stream.isVisible}}{{view Chat.QueryStreamView streamBinding="stream"}}{{/if}}
        {{/each}}
      </div>


      {{outlet}}
    """

  isExpanded: true

  actions:
    toggleExpansion: ->
      @expand not @get("isExpanded")

  expand: (expand) ->
    links = @$('.nav-0 li')
    if expand
      $('body').removeClass('contracted')
      links.tooltip('destroy')
    else
      $('body').addClass('contracted')
      links.each (i, link) ->
        $(link).tooltip
          placement: 'right'
          title: $(link).text()
          animation: false
    @set "isExpanded", expand

