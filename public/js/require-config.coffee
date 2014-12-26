requirejs.config
  baseUrl: "/js"
  deps: ['threejs', 'bootstrap', 'underscore', 'd3', 'moment', 'marked', 'colorpicker', 'datepicker']
  waitSeconds: 200
  paths:
    text: '../lib/require-text'
    json: '../lib/require/json'
    datepicker: '../lib/bootstrap-modules/datetimepicker/js/bootstrap-datetimepicker.min'
    moment: '../lib/moment.min'
    marked: '../lib/marked.min'
    handlebars: '../lib/handlebars-2.0.0.min'
    bootstrap: '../lib/bootstrap/js/bootstrap.min'
    underscore: '../lib/underscore'
    threejs: '../lib/three'
    typeahead: '../lib/bootstrap-modules/typeahead/bootstrap3-typeahead.min'
    colorpicker: '../lib/bootstrap-modules/colorpicker/js/bootstrap-colorpicker.min'
    hammer: '../lib/hammer.min'
    d3: '../lib/d3.min'

