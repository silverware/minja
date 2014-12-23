tournamentDao = require '../daos/tournamentDao'
chatDao = require '../daos/chatDao'
sports = require '../models/sports'
ControllerBase = require './controllerBase'
config = require "./../server-config"
request = require 'request'
_ = require 'underscore'
fs = require 'fs'
less = require 'less'
colorService = require '../services/colorService'

class TournamentController extends ControllerBase

  viewPrefix: "tournament"

  params:
    tid: (req, res, next, id) =>
      tournamentDao.findTournamentByIdentifier id, (tournament) =>
        if tournament
          if config.isDevelopment
            tournament.isOwner = true
          else
            tournament.isOwner = req.isAuthenticated() and tournament.user_id == req.user.id
          if req.isAuthenticated() and _.contains req.user.favorites, tournament.id
            tournament.isFavorite = true
          if tournament.publicName
            tournament.identifier = tournament.publicName
          else
            tournament.identifier = tournament.id

          req.tournament = tournament
          res.locals.tournament = tournament
          res.locals.title = tournament.name
          res.locals.navigation = @navigation req
          next()
        else
          res.status 404
          res.render "404"

  @navigation: (req) ->
    tournament = req.tournament
    id = tournament.identifier
    nav = [route: "info", icon: "info-circle", label: req.i18n.info.navName]
    if tournament.isOwner or tournament.members
      nav.push route: "participants", icon: "group", label: req.i18n.members.navName
    if tournament.isOwner or tournament.tree
      nav.push route: "bracket", icon: "sitemap fa-rotate-180", label: req.i18n.tree.navName
    # if config.isDevelopment
    #   if tournament.isOwner or tournament.gallery
    #     nav.push route: "/#{id}/gallery", icon: "picture", label: req.i18n.gallery.navName
    nav.push route: "chat", icon: "wechat", label: req.i18n.chat.messageStream, xs: true
    if tournament.isOwner
      nav.push route: "settings", icon: "cog", label: req.i18n.settings.navName, xs: true

    for navItem in nav
      navItem.selectedClass = "active" if req.url.indexOf(navItem.route) isnt - 1
    nav

  "/tournaments": (req, res) =>
    res.render "tournaments"

  "/tournament/create": [@ensureAuthenticated, (req, res) ->
    res.locals.sports = sports
    res.render "#{@viewPrefix}/create"
  ]

  "/tournament/checkPublicName": (req, res) =>
    publicName = req.param "publicName"
    tournamentDao.checkPublicName publicName, (isAvailable) ->
      res.send isAvailable

  "POST:/tournament/create": [@ensureAuthenticated, (req, res) ->
    newTournament =
      info:
        name: req.param "name"
      sport: req.param "sport"
      user_id: req.user.id

    tournamentDao.save newTournament, (result) =>
      message =
        tournament_id: result.id
        text: req.i18n.chat.tournamentCreated
        authorType: chatDao.authorTypes.leader
      chatDao.save message, ->
      res.redirect "#{result.id}/info"
  ]

  "/:tid": (req, res) =>
    res.locals.sport = if req.tournament.sport then sports[req.tournament.sport] else sports.other
    res.render "#{@viewPrefix}/index",
      editable: req.tournament.isOwner
      colors: colorService.getColors req.tournament

  "/:tid/info": (req, res) =>
    if req.tournament.isOwner and not req.tournament.info.description?
      @redirectToEdit req, res
    res.render "#{@viewPrefix}/info"

  "/:tid/participants": (req, res) =>
    if req.tournament.isOwner and not req.tournament.members?
      @redirectToEdit req, res
    res.render "#{@viewPrefix}/members"

  "/:tid/tree": (req, res) =>
    res.redirect "/#{req.params.tid}/bracket"

  "/:tid/bracket": (req, res) =>
    if req.tournament.isOwner and not req.tournament.tree?
      @redirectToEdit req, res
    res.locals.sport = if req.tournament.sport then sports[req.tournament.sport] else sports.other
    res.render "#{@viewPrefix}/tree",
      editable: false
      colors: colorService.getColors req.tournament

  "/:tid/dashboard": (req, res) =>
    res.render "#{@viewPrefix}/dashboard"

  "/:tid/gallery": (req, res) =>
    if req.tournament.isOwner and not req.tournament.gallery?
      @redirectToEdit req, res
    res.render "#{@viewPrefix}/gallery",
      editable: false

  "/:tid/chat": (req, res) =>
    res.render "#{@viewPrefix}/chat",
      editable: false

  "/:tid/image/:imageId": (req, res) =>
    url = config.DB_URL + "/tournaments/#{req.params.tid}/image/#{req.params.imageId}"
    request(url: url).pipe(res)

  "/:tid/logo/display": (req, res) =>
    url = config.DB_URL + "/tournaments/#{req.params.tid}/logo"
    request(url: url).pipe(res)

  "/:tid/messages": (req, res) =>
    paginator =
      first: req.param "first" or 0
      limit: req.param "limit" or 5
    chatDao.findMessagesByTournamentId req.tournament.id, req.i18n, paginator, (messages) ->
      res.send messages

  "POST:/:tid/messages/create": (req, res) =>
    message = req.param "message"
    if not message.text then return
    message.tournament_id = req.tournament.id

    if req.tournament.isOwner
      message.authorType = chatDao.authorTypes.leader
    else
      message.authorType = chatDao.authorTypes.guest

    chatDao.save message, ->
      res.send "ok"

  "/:tid/tournament_colors.css": (req, res) =>
    path = config.CLIENT_DIR + "/less/colors_template.less"
    colors = colorService.getColors req.tournament
    contentOpaque = colorService.opaque colors.content
    linkColor = colorService.generateLinkColor colors
    prefix = """
      @normal: #{colors.content};
      @textColor: #{colors.contentText};
      @light: #{colors.background};
      @dark: #{colors.footer};
      @footerText: #{colors.footerText};
      @normalOpaque: #{contentOpaque};
    """

    fs.readFile path, "utf8", (err, data) ->
      if err then throw err
      data = prefix.concat data
      less.render data, (err, css) ->
        if err then throw err
        res.header "Content-type", "text/css"
        res.send css

  "/:tid/colors": (req, res) =>
    colors = colorService.getColors req.tournament
    res.send colors

module.exports = new TournamentController()
