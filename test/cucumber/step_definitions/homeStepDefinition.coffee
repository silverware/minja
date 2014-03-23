world = require("../support/world").World


aTest = ->

  @world = world
  @givenNumber = 0

  @Given /^a variable set to (\d+)$/, (number, next) ->
    @givenNumber = parseInt(number)
    console.log "huhuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"
    next()

  @When /^I increment the variable by (\d+)$/, (number, next) ->
    @givenNumber = @givenNumber + parseInt(number)
    next()

  @Then /^the variable should contain (\d+)$/, (number, next) ->
    if (@givenNumber isnt number)
      throw(new Error("This test didn't pass, givenNumber is " + @givenNumber + " expected 0"))
    next()

module.exports = aTest
