App.ApplicationView = Em.View.extend
  classNames: ['chat']
  defaultTemplate: Ember.Handlebars.compile """
  hallos asdf asdf adsfadf

  a
  sdfasdl�fkj
    {{outlet}}
    """

  isExpanded: true

  actions:
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

