'use strict'

assert = require('assert')

describe 'grunt-webdriver test', ->
  it 'checks if title contains the search query', (done) ->
    browser
      .url('http://github.com')
      .setValue('#js-command-bar-field','grunt-webdriver')
      .submitForm('.command-bar-form')
      .getTitle (err,title) ->
        assert(title.indexOf('grunt-webdriver') isnt -1)
      .call(done)
