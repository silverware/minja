App.templates.info = """
  <style type="text/css">
  dl {
    font-size: 16px;
  }
  </style>
  <div class="container container-normal">
    <% if @tournament.isOwner: %>
      <%= @headerAction @i18n.edit, "info/edit", "edit" %>
    <% end %>
    <h1>{{App.i18n.info.header}}</h1>
    <dl class="dl-horizontal">
      <dt>{{App.i18n.info.startDate}}</dt>
      <dd itemprop="startDate" content="<%= @printDateDbFormat @tournament.info.startDate %>">
        <%= @printDateAndTime @i18n.parseAndPrintDate(@tournament.info.startDate), @tournament.info.startTime, true %>
      </dd>
      {{#if App.Tournament.info.stopDate}}
        <dt>{{App.i18n.info.stopDate}}</dt>
        <dd><%= @printDateAndTime @i18n.parseAndPrintDate(@tournament.info.stopDate), @tournament.info.stopTime, true %></dd>
      {{/if}}
      <dt>{{App.i18n.info.venue}}</dt>
      <span itemprop="location" itemscope itemtype="http://schema.org/Place">
      <dd itemprop="name">{{App.Tournament.info.venue}}</dd>
      </span>
    </dl>
      <dl class="dl-horizontal">
      <dt>{{App.i18n.info.host}}</dt>
      <dd>{{App.Tournament.info.host}}</dd>
      <dt>E-Mail</dt>
      <dd>{{App.Tournament.info.hostMail}}
    </dl>
    <div itemprop="description" id="description">{{App.Tournament.info.descriptionCompiled}}</div>
  </div>
"""

App.InfoView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.info

  didInsertElement: ->
    @_super()

