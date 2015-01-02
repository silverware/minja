App.ColorSelectionPopup = Ember.View.extend
  themes: App.ColorThemes.list()
  template: Ember.Handlebars.compile """
    {{#each theme in view.themes}}
      <div class="selection-item" {{action 'selectTheme' theme target="view"}} style="background-color: {{unbound theme.background}} !important">
        <div class="theme-navigation" style="background-color: {{unbound theme.footer}} !important"></div>
        <div class="theme-container" style="background-color: {{unbound theme.content}} !important"></div>
      </div>
    {{/each}}
    <div style="clear: both"></div>
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
