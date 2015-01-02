App.EditLinkComponent = Ember.Component.extend
  editable: true
  route: 'info'

  layout: Ember.Handlebars.compile """
    {{#if isOwner}}
    {{#link-to route class='float-right'}}
      <button class="btn btn-inverse"><i class="fa fa-{{unbound icon}}"></i>{{label}}</button>
    {{/link-to}}
    {{/if}}
  """

  label: (->
    if @get 'editable'
      return App.i18n.show
    return App.i18n.edit
  ).property('editable')

  icon: (->
    if @get 'editable'
      return 'eye'
    return 'edit'
  ).property('editable')

  isOwner: (->
    App.tournament.isOwner
  ).property('App.tournament.isOwner')
