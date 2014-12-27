App.ApplicationView = Em.View.extend
  classNames: ['chat']
  defaultTemplate: Ember.Handlebars.compile """
    {{outlet}}
    {{outlet detailView}}
    """

  didInsertElement: ->
    @_super()
    console.debug "Application view"

  isExpanded: true

  actions:
    openDetailView: (detailView) ->
      return this.render detailView,
        into: 'application'
        outlet: 'detailView'

    toggleExpansion: ->
      @expand not @get("isExpanded")

  expand: (expand) ->
    links = @$('.nav-0 li')
    if expand
      $('body').removeClass('contracted')
      links.tooltip('destroy')
    else
      $('body').addClass('contracted')
      links.each (i, link) ->
        $(link).tooltip
          placement: 'right'
          title: $(link).text()
          animation: false
    @set "isExpanded", expand

