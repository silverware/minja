requirejs.config
  baseUrl: "/js"
  waitSeconds: 200
  deps: ['jquery', 'handlebars']
  paths:
    text: '../lib/require-text'
    json: '../lib/require/json'
    datepicker: '../lib/bootstrap-modules/datetimepicker/js/bootstrap-datetimepicker.min'
    moment: '../lib/moment.min'
    marked: '../lib/marked.min'
    handlebars: '../lib/handlebars-2.0.0'
    ember: '../lib/ember-1.9.1'
    bootstrap: '../lib/bootstrap/js/bootstrap.min'
    underscore: '../lib/underscore'
    threejs: '../lib/three'
    typeahead: '../lib/bootstrap-modules/typeahead/bootstrap3-typeahead.min'
    colorpicker: '../lib/bootstrap-modules/colorpicker/js/bootstrap-colorpicker.min'
    background: 'utils/background/BackgroundRenderer'
    popup: 'utils/popup'
    # hammer: '../lib/hammer.min'
    d3: '../lib/d3.min'
    chosen: "../lib/chosen.jquery.min"
    validate: "../lib/jquery.validate.min"
    jquery: "../lib/jquery-1.8.0.min"
    jqueryui: "../lib/jquery-ui"
    main: "./main"
    formvalidator: "./form/FormValidator"
    save: "./form/Save"
  shim:
    colorpicker: ['jquery']
    datepicker: ['jquery']
    main: ['jquery']
    formvalidator: ['jquery', 'validate']
    validate: ['jquery']
    save: ['jquery']
    jqueryui: ['jquery']
    underscore:
      exports: '_'
    threejs:
      exports: 'THREE'
    bootstrap: ['moment', 'jquery']
    ember:
      deps: ['handlebars', 'jquery']
      exports: 'Ember'
    jquery:
      init: ->
        window.$ = window.jQuery

require ['background', 'main', 'popup', 'formvalidator', 'save', 'jqueryui', 'jquery', 'validate', 'underscore', 'marked', 'handlebars', 'ember', 'threejs', 'moment', 'bootstrap', 'd3', 'colorpicker', 'datepicker']
