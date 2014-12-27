App.PrettyDateTimeComponent = Ember.Component.extend
  date: ''
  time: ''
  withIcon: false

  layout: Ember.Handlebars.compile """
    {{#if date}}
      {{#if withIcon}}
        <i class="fa fa-calendar"></i>&nbsp;
      {{/if}}
      {{prettyDate}}
      {{#if time}}
        &nbsp;&nbsp;&nbsp;<i class="fa fa-clock-o"></i>&nbsp;{{time}}
      {{/if}}
    {{else}}
      N/A
    {{/if}}
    """

  prettyDate: (->
    moment.lang App.i18n.lang
    moment(@get('date'), "DD.MM.YYYY").format "dddd, DD. MMMM YYYY"
  ).property()

  didInsertElement: ->
    @_super()
