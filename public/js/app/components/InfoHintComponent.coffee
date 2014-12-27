App.InfoHintComponent = Ember.Component.extend
  classNames: ['info-hint']

  layout: Ember.Handlebars.compile """
    <i class="fa fa-info-circle"></i>
    <div>{{yield}}</div>
  """


