App.templates.info = """
  <style type="text/css">
  dl {
    font-size: 16px;
  }
  </style>
  <div class="container container-normal">
    {{edit-link editable=editable route="info.edit"}} 
    <h1>{{App.i18n.info.header}}</h1>
    <dl class="dl-horizontal">
      <dt>{{App.i18n.info.startDate}}</dt>
      <dd itemprop="startDate" content="<%= @printDateDbFormat @tournament.info.startDate %>">
        {{App.tournament.info.startDate}}
      </dd>
      {{#if App.tournament.info.stopDate}}
        <dt>{{App.i18n.info.stopDate}}</dt>
        <dd><%= @printDateAndTime @i18n.parseAndPrintDate(@tournament.info.stopDate), @tournament.info.stopTime, true %></dd>
      {{/if}}
      <dt>{{App.i18n.info.venue}}</dt>
      <span itemprop="location" itemscope itemtype="http://schema.org/Place">
      <dd itemprop="name">{{App.tournament.info.venue}}</dd>
      </span>
    </dl>
      <dl class="dl-horizontal">
      <dt>{{App.i18n.info.host}}</dt>
      <dd>{{App.tournament.info.host}}</dd>
      <dt>E-Mail</dt>
      <dd>{{App.tournament.info.hostMail}}
    </dl>
    <div itemprop="description" id="description">{{App.tournament.info.descriptionCompiled}}</div>
  </div>
"""

App.InfoView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.info

  didInsertElement: ->
    @_super()

