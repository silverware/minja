define ["utils/Popup", "./ColorThemes"], (Popup, themes) ->

  template = """
    {{#each theme in view.themes}}
      <div class="selection-item" {{action onSelection theme target="view"}}>
        {{theme.name}}
        <img />
      </div>
    {{/each}}
  """

  view = Ember.View.extend
    template: Ember.Handlebars.compile template
    i18n: null
    themes: themes

    init: ->
      @_super()
      @append Ember.Application.create
        rootElement: ".modal"
      Popup.show
        title: @i18n.colorSelection
        cancelble: false
        bodyContent: @

    onSelection: ->
      # extension point

