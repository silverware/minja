App.MarkdownComponent = Ember.Component.extend
  text: null

  template: Ember.Handlebars.compile """
    {{markedText}}
  """

  markedText: (->
    marked @get('text')
  ).property('text')




