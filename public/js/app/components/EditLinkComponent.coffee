App.EditLinkComponent = Ember.Component.extend
  editable: true
  route: 'info'

  template: Ember.Handlebars.compile """
    {{#link-to url}}
      <button class="btn btn-inverse"><i class="fa fa-{{icon}}"></i>{{label}}</button>
    {{/link-to}}
  """

  url: (->
    if @get 'editable'
      return @get 'route'
    return @get('route') + '/edit'
  ).property('editable', 'route')

  label: (->
    if @get 'editable'
      return App.i18n.view
    return App.i18n.edit
  ).property('editable')

  icon: (->
    if @get 'editable'
      return 'eye'
    return 'edit'
  ).property('editable')
