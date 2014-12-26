App.ColorSelectionPopup = Ember.View.extend
  themes: App.ColorThemes.list()
  template: Ember.Handlebars.compile """
    {{#each theme in view.themes}}
      <div class="selection-item" {{action 'selectTheme' theme target="view"}}>
        {{theme.name}}
        <img />
      </div>
    {{/each}}
  """

  init: ->
    @_super()
    App.Popup.show
      title: App.i18n.settings.colorSelection
      cancelble: false
      bodyContent: @

  actions:
    selectTheme: (theme) ->
      @onSelection theme

  onSelection: ->
    # extension point
