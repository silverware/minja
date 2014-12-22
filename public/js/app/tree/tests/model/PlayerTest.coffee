buster.testCase "Player Model",
  setUp: ->
    @hans = App.Player.createPlayer name: "Hans"
    @peter = App.Player.createPlayer name: "Peter"

  "real player check": ->
    assert.equals true, @hans.get('isRealPlayer')
    @hans.set 'isPrivate', true
    assert.equals false, @hans.get('isRealPlayer')

