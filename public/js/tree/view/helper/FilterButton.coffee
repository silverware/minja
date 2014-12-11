App.FilterButton = Ember.View.extend
  classNames: ['btn-group']
  content: []
  value: ''

  template: Ember.Handlebars.compile """
      <button type="button" class="btn btn-inverse dropdown-toggle" data-toggle="dropdown">
        <i class="fa fa-filter"></i>{{view.buttonLabel}} <span class="caret"></span>
      </button>
      <ul class="dropdown-menu" role="menu">
        {{#each view.content}}
          <li><a {{action "select" this target="view"}} href="#">{{label}}</a></li>
        {{/each}}
      </ul>
  """

  init: ->
    @_super()
    @set 'buttonLabel', @get 'value'

  select: (selected) ->
    @set 'buttonLabel', selected.label
    @set 'value', selected.id

  didInsertElement: ->

