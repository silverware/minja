class ControllerBase
  @ensureAuthenticated: (req, res, next) ->
    if req.isAuthenticated()
      return next()
    res.redirect "/user/login?next=#{req.path}"

  redirectToEdit: (req, res) ->
    res.redirect req.originalUrl + "/edit"

  handleError: (f) ->
    (result, error) ->
      if error then return @next()
      f(result)

module.exports = ControllerBase
