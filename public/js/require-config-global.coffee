requirejs.config
  baseUrl: "/js"
  waitSeconds: 200
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
    # hammer: '../lib/hammer.min'
    d3: '../lib/d3.min'
  shim:
    underscore:
      exports: '_'
    threejs:
      exports: 'THREE'
    ember: ['handlebars']
    bootstrap: ['moment']

require ['underscore', 'marked', 'handlebars', 'ember', 'threejs', 'moment', 'bootstrap', 'd3', 'colorpicker', 'datepicker']
