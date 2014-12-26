App.templates.info = """
  <style type="text/css">
  dl {
    font-size: 16px;
  }
  </style>
  <div class="container container-normal">
    {{edit-link editable=editable route="info.edit"}} 
    <h1>{{i18n.info.header}}</h1>
    <dl class="dl-horizontal">
      <dt>{{i18n.info.startDate}}</dt>
      <dd itemprop="startDate" content="<%= @printDateDbFormat @tournament.info.startDate %>">
        {{info.startDate}}
      </dd>
      {{#if App.tournament.info.stopDate}}
        <dt>{{i18n.info.stopDate}}</dt>
        <dd><%= @printDateAndTime @i18n.parseAndPrintDate(@tournament.info.stopDate), @tournament.info.stopTime, true %></dd>
      {{/if}}
      <dt>{{i18n.info.venue}}</dt>
      <span itemprop="location" itemscope itemtype="http://schema.org/Place">
      <dd itemprop="name">{{info.venue}}</dd>
      </span>
    </dl>
      <dl class="dl-horizontal">
      <dt>{{i18n.info.host}}</dt>
      <dd>{{info.host}}</dd>
      <dt>E-Mail</dt>
      <dd>{{info.hostMail}}
    </dl>
    <div itemprop="description" id="description">{{App.tournament.info.descriptionCompiled}}</div>
  </div>
"""

App.InfoView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.info

  didInsertElement: ->
    @_super()

