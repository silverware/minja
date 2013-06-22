define ["utils/Popup"], (Popup) ->

  template = """
    aösdfj asldfkj
  """

  Ember.View.extend
    template: Ember.Handlebars.compile template
    i18n: null

    init: ->
      popup = Popup.show
        title: @i18n.colorSelection
        actions: [{label: @i18n.applyColor, action: @setColors, closePopup: true}]
        cancelble: true
        bodyContent: @

    setColors: ->


    didInsertElement: ->
      @$().fadeIn 1000
      @$("[rel='tooltip']").tooltip()

