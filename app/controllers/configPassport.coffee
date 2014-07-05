passport = require 'passport'
config = require '../server-config'
userDao = require '../daos/userDao'
FacebookStrategy = require('passport-facebook').Strategy
LocalStrategy = require('passport-local').Strategy


passport.use(new LocalStrategy((username, password, done) =>
  userDao.findByEmail username, (user, err) =>
    if not user
      return done null, false, {message: "User #{username} not found"}

    if userDao.validPassword user, password
      return done err, user
    else
      return done null, false, message: 'Wrong password.'
))

facebookConfig =
  clientID: config.CLIENTID
  clientSecret: config.CLIENTSECRET
  callbackURL: "#{config.ROOTPATH}/auth/facebook/callback"
  enableProof: false

passport.use(new FacebookStrategy(facebookConfig, (accessToken, refreshToken, profile, done) ->
    userDao.findOrCreateByEmail profile.emails[0].value, (err, user) =>
      done err, user
))

passport.serializeUser (user, done) ->
  done null, user._id

passport.deserializeUser (id, done) ->
  userDao.find id, (user, err) ->
    done err, user

module.exports = passport
