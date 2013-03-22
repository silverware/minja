module.exports =
  isPublicName: (name) ->
    /^[a-zA-Z0-9\.]{5,}$/i.test name

