marked = require 'marked'
tournamentDao = require '../daos/tournamentDao'
errorDao = require '../daos/errorDao'

class CommonController

  "/": (req, res) =>
    res.render 'homepage'

  # "/homepage": (req, res) =>
  #   res.render 'homepage'

  "/site/impressum": (req, res) =>
    res.render 'impressum'

  "/site/sitemap": (req, res) =>
    tournamentDao.findAllTournamentIdentifiers (tournaments)->
      res.render 'sitemap',
        tournaments: tournaments
        layout: false

  "/lang/:lang": (req, res) =>
    req.session.language = req.params.lang
    res.redirect req.param "next"

  "/editor/preview": (req, res) =>
    res.send marked req.param "markdown"

  "/i18n/*": (req, res) =>
    res.send req.i18n[req.params[0]]

  "POST:/errors/report": (req, res) =>
    error = req.body
    error.isClientError = true
    error.user_id = req.user?.id
    errorDao.save error, ->
      res.send "ok"

module.exports = new CommonController()
