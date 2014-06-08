fs = require 'fs'
tournamentDao = require '../daos/tournamentDao'
chatDao = require '../daos/chatDao'
sports = require '../models/sports'
moment = require 'moment'
ControllerBase = require './controllerBase'
config = require '../server-config'
colorService = require '../services/colorService'
_ = require "underscore"
gm = require 'gm'
gm = gm.subClass({ imageMagick: true })

class TournamentEditController extends ControllerBase

  viewPrefix: "tournament"

  before: (req, res, next) ->
    if config.isProduction
      if not req.isAuthenticated()
        res.redirect "/user/login?next=#{req.path}"
        return
      if req.user.id isnt req.tournament.user_id
        res.redirect "/"
    next()

  "/:tid/participants/edit": (req, res) =>
    if not req.tournament.members?
      res.addInfo req.i18n.infoAlert.members
    res.render "#{@viewPrefix}/members/edit"

  "POST:/:tid/participants/edit": (req, res) =>
    if _.isEmpty req.body
      return res.render "#{@viewPrefix}/members/edit"
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
    res.redirect "/#{req.params.tid}/bracket/edit"

  "/:tid/bracket/edit": (req, res) =>
    if not req.tournament.tree?
      res.addInfo req.i18n.infoAlert.tree
    res.locals.sport = if req.tournament.sport then sports[req.tournament.sport] else sports.other
    res.render "#{@viewPrefix}/tree",
      editable: true
      colors: colorService.getColors req.tournament

  "POST:/:tid/bracket/edit": (req, res) =>
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
    # if req.tournament.publicName then res.send 500
    tournamentDao.checkPublicName publicName, (isAvailable) ->
      if isAvailable
        tournamentDao.merge req.tournament.id, publicName: publicName, ->
          res.send "ok"
      else
        res.send 500

  "/:tid/logo": (req, res) =>
    hasLogo = req.tournament.hasLogo == true

    res.render "#{@viewPrefix}/settings",
      hasLogo: hasLogo

  "POST:/:tid/logo": (req, res) =>
    if req.param("save")
      hasLogo = req.tournament.hasLogo == true
      logoFile = req.files['logo']
      if logoFile.size == 0
        res.addError "No image specified"
      else if logoFile.type not in ["image/png", "image/jpg", "image/jpeg", "image/gif"]
        res.addError "Image must be of type png, jpg, or gif"

      if res.locals.errors?
        res.render "#{@viewPrefix}/settings", hasLogo: hasLogo
      else
        logo = gm(logoFile.path)
        logo.size((err, size) =>
          if (err)
            throw err
          longestSide = Math.max(size.width, size.height)
          if (longestSide > 200)
            logo.resize(200).toBuffer((err, buffer) =>
              if (err)
                throw err

              logoImage =
                name: 'logo'
                contentType: logoFile.type
                body: buffer

              tournamentDao.saveAttachments([logoImage], req.tournament, () =>
                tournamentDao.merge req.tournament.id, hasLogo: true, () =>
                  res.render "#{@viewPrefix}/settings", hasLogo: true)
            )
        )

    else
      tournamentDao.merge req.tournament.id, hasLogo: false, () =>
        tournamentDao.removeAttachments( req.tournament, ["logo"], () =>
          res.render "#{@viewPrefix}/settings", hasLogo: false)

  "/:tid/settings": (req, res) =>
    tournament = res.locals.tournament
    if not colorService.isColorSelected req.tournament
      tournament.colors = colorService.defaultColors

    res.render "#{@viewPrefix}/settings"
      hasLogo: req.tournament.hasLogo

  "POST:/:tid/settings/colors": (req, res) =>
    if colorService.isDefaultColor req.body
      req.body = null
    tournamentDao.merge req.tournament.id, colors: req.body, =>
      res.redirect "/#{req.tournament.id}/settings"

module.exports = new TournamentEditController()
