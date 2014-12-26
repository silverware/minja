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
      <dd itemprop="startDate" content="{{unbound info.startDateDb}}">
        {{pretty-date-time withIcon=true date=info.startDate time=info.startTime}}
      </dd>
      {{#if info.stopDate}}
        <dt>{{i18n.info.stopDate}}</dt>
        <dd>
          {{pretty-date-time withIcon=true date=info.stopDate time=info.stopTime}}
        </dd>
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
    <div itemprop="description" id="description">{{mark-down text=info.description}}</div>
  </div>
"""

App.InfoView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.info

  didInsertElement: ->
    @_super()

