formHelper = require "../helper/form_helper"
viewHelper = require "../helper/view_helper"
i18n = require "../languages/i18n"
passport = require './config_passport'

controllers = [
  require "./common_controller"
  require "./login_controller"
  require "./user_controller"
  require "./tournament_controller"
  require "./tournament_edit_controller"
]

module.exports = (app) ->
  app.use passport.initialize()
  app.use passport.session()
  app.use i18n
  # Helper
  app.use formHelper
  app.use viewHelper

  #Error Handler
  app.use (err, req, res, next) ->
    console.error err.stack
    if req.xhr
      res.send 500, error: 'Something blew up!'
    else
      res.status 500
      res.render '500', {error: err}

  process.on 'uncaughtException', (err) ->
    console.log err, "oops"

  # Param Settings
  for controller in controllers
    for param, func of controller.params
        app.param param, func

  # Routes
  for controller in controllers
    middleware = []

    # add before middleware
    for route, func of controller
      if route is 'before'
        middleware.push func

    for route, func of controller
      if route.indexOf("/") == 0
        if func.length
          f = func.pop()
          app.get route, middleware.concat(func), f.bind(controller)
        else
          app.get route, middleware, func
        console.log route
      else if route.indexOf("POST:") == 0
        route = route.replace("POST:", "")
        if func.length
          f = func.pop()
          app.post route, middleware.concat(func), f.bind(controller)
        else
          app.post route, middleware, func
        console.log route, "POST"


  app.get /^\/([^\s]+)\.template$/, (req, res) ->
    res.render req.params[0],
      layout: false


