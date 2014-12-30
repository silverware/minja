App.DetailView = Em.View.extend
  classNameBindings: ['controller.isHidden:hide']
  classNames: ['detailView']

  layout: Ember.Handlebars.compile """
    <span title="close" class="closeButton right noPrint" {{action 'closeDetailView'}}>
      <i class="fa fa-times-circle"></i>
    </span>
    <div class="detailContent">{{yield}}</div>
  """

  didInsertElement: ->
    @_super()

  hide: ->
    @$().hide()

  show: ->
    @$().fadeIn 'medium'
