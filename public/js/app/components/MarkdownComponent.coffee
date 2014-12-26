App.MarkDownComponent = Ember.Component.extend
  text: null

  layout: Ember.Handlebars.compile """
    {{markedText}}
  """

  markedText: (->
    new Handlebars.SafeString marked @get('text')
  ).property('text')




