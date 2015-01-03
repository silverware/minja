requirejs.config
  baseUrl: "/js"
  waitSeconds: 200
  deps: ['jquery']
  paths:
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
    # hammer: '../lib/hammer.min'
    d3: '../lib/d3.min'
    modernizr: '../lib/modernizr'
    mobiledetect: '../lib/mobile-detect'
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
    typeahead: ['bootstrap']
    main: ['jquery']
    formvalidator: ['jquery', 'validate']
    validate: ['jquery']
    save: ['jquery', 'validate', 'formvalidator', 'main']
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
      exports: '$'
      init: ->
        window.$ = window.jQuery

require ['background', 'modernizr', 'mobiledetect', 'main', 'formvalidator', 'save', 'jqueryui', 'jquery', 'validate', 'underscore', 'marked', 'handlebars', 'ember', 'threejs', 'moment', 'bootstrap', 'd3', 'colorpicker', 'datepicker', 'typeahead']
