tournamentDao = require '../dao/TournamentDao'
chatDao = require '../dao/ChatDao'
sports = require '../model/sports'
moment = require 'moment'
ControllerBase = require './controller_base'
config = require '../server-config'

class TournamentEditController extends ControllerBase

  viewPrefix: "tournament"

  before: (req, res, next) ->
    if config.isProduction
      if not req.isAuthenticated() 
        res.redirect "/login?next=#{req.path}"
        return
      if req.user.id != req.tournament.user_id
        res.redirect "/"
    next()

  "/:tid/members/edit": (req, res) =>
    if not req.tournament.members?
      res.addInfo req.i18n.infoAlert.members
    res.render "#{@viewPrefix}/members/edit"

  "POST:/:tid/members/edit": (req, res) =>
    tournamentDao.merge req.tournament.id, members: req.body, ->
      res.send "ok"

  "/:tid/info/edit": (req, res) =>
    if not req.tournament.info.description?
      res.addInfo req.i18n.infoAlert.info
    tournament = res.locals.tournament
    tournament.info.startDate = moment().format("DD.MM.YYYY") if not tournament.info.startDate
    res.render "#{@viewPrefix}/info/edit"

  "POST:/:tid/info/edit": (req, res) =>
    tournamentDao.merge req.tournament.id, info: req.body, ->
      res.send "ok"

  "/:tid/tree/edit": (req, res) =>
    if not req.tournament.tree?
      res.addInfo req.i18n.infoAlert.tree
    res.locals.sport = if req.tournament.sport then sports[req.tournament.sport] else sports.other
    res.render "#{@viewPrefix}/tree",
      editable: true

  "POST:/:tid/tree/edit": (req, res) =>
    tournamentDao.merge req.tournament.id, tree: req.body, ->
      res.send "ok"

  "/:tid/gallery/edit": (req, res) =>
    if not req.tournament.gallery?
      res.addInfo req.i18n.infoAlert.gallery
    res.render "#{@viewPrefix}/gallery",
      editable: true

  "POST:/:tid/gallery/edit": (req, res) =>
    req.body = {} if req.body.empty?
    tournamentDao.merge req.tournament.id, gallery: req.body, (result) ->
      tournamentDao.mergeImages result, req.tournament._attachments, req.body, req.files, ->
        res.send "ok"

  "/:tid/duplicate": (req, res) =>
    newTournament =
      info: req.tournament.info
      user_id: req.user.id
      members: req.tournament.members
      tree: req.tournament.tree
      gallery: req.tournament.gallery
    newTournament.info.name += " [#{req.i18n.copied}]"
    tournamentDao.save newTournament, =>
      res.redirect "/me/tournaments"

  "/:tid/remove": (req, res) =>
    tournamentDao.remove req.tournament.id, req.tournament.rev, ->
      res.redirect "/me/tournaments"

  "POST:/:tid/messages/remove": (req, res) =>
    chatDao.remove req.param("id"), req.param("rev"), ->
      res.send "ok"

  "POST:/:tid/savePublicName": (req, res) =>
    publicName = req.param("publicName").toLowerCase()
    if req.tournament.publicName then res.send 500
    tournamentDao.checkPublicName publicName, (isAvailable) ->
      if isAvailable
        tournamentDao.merge req.tournament.id, publicName: publicName, ->
          res.send "ok"

  "/:tid/logo": (req, res) =>
    hasLogo = false
    if req.tournament.logo
      hasLogo = true

    res.render "#{@viewPrefix}/logo",
      hasLogo: hasLogo

module.exports = new TournamentEditController()
