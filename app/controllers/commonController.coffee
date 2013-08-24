marked = require 'marked'
tournamentDao = require '../daos/tournamentDao'
class CommonController

  "/": (req, res) =>
    res.render 'index'

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


module.exports = new CommonController()
