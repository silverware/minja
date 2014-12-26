App.PrettyDateTimeComponent = Ember.Component.extend
  date: ''
  time: ''
  withIcon: false

  layout: Ember.Handlebars.compile """
    {{#if hasDate}}
      {{#if withIcon}}
        <i class="fa fa-calendar"></i>&nbsp;
      {{/if}}
      {{prettyDate}}
      {{#if hasTime}}
        &nbsp;&nbsp;&nbsp;<i class="fa fa-clock-o"></i>&nbsp;{{time}}
      {{/if}}
    {{else}}
      N/A
    {{/if}}
    """

  hasDate: (->
    @get('date') isnt null
  ).property()

  hasTime: (->
    @get('time') isnt null
  ).property()

  prettyDate: (->
    moment.lang App.i18n.lang
    moment(@get('date'), "DD.MM.YYYY").format "dddd, DD. MMMM YYYY"
  ).property()

  didInsertElement: ->
    @_super()
