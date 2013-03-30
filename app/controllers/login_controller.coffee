userDao = require '../dao/UserDao'
passport = require 'passport'
crypto = require 'crypto'
emailService = require '../services/emailService'
_ = require 'underscore'
moment = require 'moment'
passport = require './config_passport'

class LoginController

  viewPrefix: "login"

  "POST:/user/lostpassword": (req, res) =>
    email = req.param "email"
    res.locals.email = email
    userDao.findByEmail email, (user) =>
      if not user
        res.addError "#{email} is not registered."
        res.render "#{@viewPrefix}/lostpassword"
      else
        changePasswordSecret = userDao.generateSecretHash()
        now = new Date()

        if not user.password_requests?
          user.password_requests = []

        user.password_requests.push
          secret: changePasswordSecret
          created_at: now

        userDao.merge user._id, user, =>
          emailService.sendPasswordRecoveryEmail user, changePasswordSecret, (err, message) =>
            if err
              res.addError "Oops"
            else
              res.addInfo "A password recovery E-mail was sent to you"
            res.render "#{@viewPrefix}/lostpassword"

  "/user/lostpassword": (req, res) =>
    res.render "#{@viewPrefix}/lostpassword"

  "POST:/user/recoverpassword": (req, res) =>
    secret = req.param "secret"
    userId = req.param "user"
    newpassword1 = req.param "newpassword1"
    newpassword2 = req.param "newpassword2"

    userDao.find userId, (user) =>
      if not user
        res.addError "Cannot find user with user id"
      else
        foundSecret = false
        for password_request in user.password_requests
          if password_request.secret == secret
            created_at = moment(password_request.created_at)
            now = moment()
            if (now.diff(created_at, 'hours') <= 24)
              foundSecret = true

        if not foundSecret
          res.addError "Your password recovery link is invalid or too old."

        if newpassword1 != newpassword2
          res.addError "Passwords do not match."
        else if (newpassword1 == "")
          res.addError "Password cannot be empty."

      if not res.locals.errors?
        user.password = userDao.hashPassword newpassword1
        user.password_requests = []
        userDao.merge user.id, user, =>
          res.addInfo "Password changed"
          res.render "#{@viewPrefix}/login"
      else
        res.render "#{@viewPrefix}/recoverpassword"

  "/user/recoverpassword": (req, res) =>
    secret = req.param "secret"
    userId = req.param "user"

    if not secret? or not userId?
      return res.render "404"

    userDao.find userId, (user) =>
      if not user
        return res.render "404"

      password =
        newpassword1: ''
        newpassword2: ''
      res.render "#{@viewPrefix}/recoverpassword", password: password, user: userId, secret: secret

  "POST:/user/register": (req, res) =>
    email = req.param "email"
    res.locals.email = email
    userDao.findByEmail email, (user) =>
      if user
        res.addError req.i18n.userAlreadyExists
        res.render "#{@viewPrefix}/register"
      else
        password = userDao.generatePassword()
        userDao.create email, password, =>

          # send mail with password
          emailService.sendWelcomeEmail email, password, (err, message) =>
              if err
                res.addError 'E-Mail sending failed'
                res.render "#{@viewPrefix}/register"
              else
                res.addInfo req.i18n.passwordSent
                res.render "#{@viewPrefix}/login"

  "/user/register": (req, res) =>
    res.render "#{@viewPrefix}/register"

  "/user/login": (req, res) =>
    next = if req.param "next" then req.param "next" else ''
    res.render "#{@viewPrefix}/login", next: next, message: req.flash 'error'

  "/user/logout": (req, res) =>
    req.logOut()
    res.redirect "/"

  "POST:/user/login": [passport.authenticate('local', {failureRedirect: '/login', failureFlash: true}), (req, res) ->
      if req.param "next"
        res.redirect req.param "next"
      else res.redirect "/me/tournaments"
  ]

  "/auth/facebook": [passport.authenticate('facebook', {scope:['email']})]

  "/auth/facebook/callback": [passport.authenticate('facebook', failureRedirect: '/login'), (req, res) ->
    res.redirect "/me/tournaments"
  ]

module.exports = new LoginController()

