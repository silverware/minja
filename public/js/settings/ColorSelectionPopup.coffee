define ["utils/Popup"], (Popup) ->

  template = """
    {{#each theme in view.themes}}
      <div {{action select target="view" context="theme"}}>{{theme.name}}</div>
    {{/each}}
  """

  Ember.View.extend
    template: Ember.Handlebars.compile template
    i18n: null
    themes: []

    init: ->
      @_super()
      popup = Popup.show
        title: @i18n.colorSelection
        actions: [{label: @i18n.applyColor, action: @setColors, closePopup: true}]
        cancelble: false
        bodyContent: @

    select: (ev) ->
      console.debug "sldkfj", ev

    onSelection: ->
      console.debug "lsdfjkl"

    didInsertElement: ->
      @$().fadeIn 1000
      @$("[rel='tooltip']").tooltip()

