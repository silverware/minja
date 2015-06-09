App.templates.info = """
  <div class="container container-normal">
    {{edit-link editable=false route="info.edit"}}
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
      <dd itemprop="name">{{#if info.venue}}{{info.venue}}{{else}}N/A{{/if}}</dd>
      </span>
    </dl>
    <dl class="dl-horizontal">
      <dt>{{i18n.info.host}}</dt>
      <dd>{{#if info.host}}{{info.host}}{{else}}N/A{{/if}}</dd>
      <dt>E-Mail</dt>
      <dd>{{#if info.hostMail}}{{info.hostMail}}{{else}}N/A{{/if}}</dd>
    </dl>
    <br class="clear" />
    <div itemprop="description" id="description">{{mark-down text=info.description}}</div>
  </div>
"""

App.InfoView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.info

  didInsertElement: ->
    @_super()

