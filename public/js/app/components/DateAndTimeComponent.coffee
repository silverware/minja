App.DateAndTimeComponent = Ember.Component.extend
  date: null
  time: null

  template: Ember.Handlebars.compile """
    {{#if date}}
      <i class="fa fa-calendar"></i>&nbsp;{{beautifulDate}}
      &nbsp;&nbsp;&nbsp;<i class="fa fa-clock-o"></i>&nbsp;{{time}}
    {{/else}}
      n/a
    {{/if}}
  """

  beautifulDate: (->
    moment.lang App.i18n.lang
    if @get('date')
      moment(@get('date'), "DD.MM.YYYY").format "dddd, DD MMMM YYYY"
  ).property('date')




