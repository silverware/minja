userDao = require '../daos/userDao'
tournamentDao = require '../daos/tournamentDao'
ControllerBase = require './controllerBase'
{toggleItemInList} = require '../services/utilsService'

class UserController extends ControllerBase

  viewPrefix: "user"

  before: @ensureAuthenticated

  "/me/changepassword": (req, res) =>
    res.render "#{@viewPrefix}/changepassword"

  "POST:/me/changepassword": (req, res) =>
    if not req.user.password?
      res.addError "You cannot change your password as a facebook user"
    if req.user.email is 'test@example.com'
      res.addError "The Demo User is not allowed to change password"

    oldpassword = req.param("oldpassword")
    newpassword1 = req.param("newpassword1")
    newpassword2 = req.param("newpassword2")
    hash = userDao.hashPassword

    if newpassword1 isnt newpassword2
      res.addError "Passwords do not match."

    if hash(oldpassword) isnt req.user.password
      res.addError "Wrong old password"

    if not newpassword1
      res.addError "Password cannot be empty"

    if not res.locals.errors?
      user = req.user
      user.password = hash(newpassword1)
      userDao.merge user.id, user, =>
      res.addInfo "Password successfully changed"
    res.render "#{@viewPrefix}/changepassword"


  "/me/tournaments": (req, res) =>
    tournamentDao.findTournamentsByUser req.user, (tournaments) =>
      if tournaments.length is 0
        res.addInfo req.i18n.noTournamentsCreated
      res.render "#{@viewPrefix}/mytournaments",
        tournaments: tournaments

  "/me/favorites": (req, res) =>
    tournamentDao.findTournamentsByIds req.user.favorites, (tournaments) =>
      if tournaments.length is 0
        res.addInfo req.i18n.noTournamentsInFavorites
      res.render "#{@viewPrefix}/favorites",
        favoriteTournaments: tournaments

  "POST:/me/favorites/toggle": (req, res) =>
    tid = req.param "tid"
    if not tid then return
    favorites = toggleItemInList req.user.favorites, tid
    userDao.merge req.user.id, favorites: favorites, =>
      res.send "ok"

module.exports = new UserController()

