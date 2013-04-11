moment = require 'moment'

module.exports = 

  show: "View"
  edit: "Edit"
  add: "Add"
  save: "Save"
  saved: "Saved"
  delete: "Delete"
  create: "Create"
  created: "Created"
  duplicate: "Clone"
  copied: "Copied"
  error: "Error"
  warning: "Warning"
  open: "Open"
  contact: "Contact"
  datum: "Date"
  time: "Time"
  contactUs: "Contact Us"
  favorites: "Favorites"

  date: (date) ->
    moment.lang 'en'
    moment(date).fromNow()

  parseAndPrintDate: (date) ->
    moment.lang 'en'
    if date
      moment(date, "DD.MM.YYYY").format "dddd, DD MMMM YYYY"

  ################################ COMMON ########################################################
  createNewTournament: "Create New Tournament"
  newTournament: "New Tournament"
  tournamentName: "Tournament Name"
  noTournamentsCreated: "Currently no tournaments created."
  noTournamentsInFavorites: "Currently no tournaments added to favorites."
  guest: "Guest"
  tournamentLeader: "Tournament Leader"



  infoAlert:
    members: "Manage the participants of your tournament."
    info: ""
    tree: """
      Dies ist die Sahneschnitte. Erstell dir den kompletten Turnierbaum, trage Ergebnisse ein und veröffentliche diesen.
    """
    gallery: "Stelle bis zu 20 Bilder hinein."


  ################################ LOGIN ########################################################
  register: "Register"
  userAlreadyExists: "A user with the same email address already exists."
  passwordSent: "Your password was sent to you."
  password: "Password"
  lostPassword: "Lost Password"
  requestPassword: "Request Password"
  myTournaments: "My Tournaments"
  tournaments: "Tournaments"
  changePassword: "Change Password"
  currentPassword: "Current Password"
  newPassword: "New Password"
  newPasswordRepeat: "New Password (Repeat)"



  ################################ GALLERY ########################################################
  gallery:
    navName: "Gallery"
    addImages: "Add Images"
    delete: "Delete"
    title: "Title"


  ################################ INFO ########################################################
  info:
    header: "Tournament Information"
    navName: "Info"
    description: "Description"
    venue: "Location"
    startDate: "Start"
    stopDate: "Stop"
    host: "Host"
    basicData: "Basic Data"
    stopTimeKnown: "Stop Date known?"
    deleteStopTime: "Delete Stop Date"
    publicName: "Public Tournament Name"
    save: "Save"
    available: "available"
    notAvailable: "not available"
  
  chat:
    delete: "Delete"
    messageStream: "Message Stream"
    publish: "Publish"
    message: "Write a Message"
    showMore: "Show More"
    tournamentCreated: "Tournament created."




################################ MEMBERS ########################################################
  members:
    navName: "Competitors"
    addAttribute: "Add Attribute"
    addMember: "Competitor"
    visibility: "Visibility"
    type: "Type"
    textfield: "Textfield"




################################ TREE ########################################################
  tree:
    navName: "Bracket"
    groupStage: "Group Stage"
    koRound: "KO Round"
    group: "Group"
    previousRound: "Previous Round"
    game: "Game"
    games: "Games"
    remove: "Remove"
    groupSizeUp: "Increase Groupsize"
    groupSizeDown: "Decrease Groupsize"    
    qualifiersUp: "Increase Qualifiercount"
    qualifiersDown: "Decrease Qualifiercount"
    winner: "Winner"
    player: "Player"
    edit: "Edit"
    qualifiers: "Qualifiers"
    schedule: "Game Schedule"
    table: "Table"
    detailView: "Detail View"
    settings: "Settings"
    save: "Save"
    pointsPerWin: "Points/Win"
    pointsPerDraw: "Points/Draw"
    timePerGame: "Minutes/Game"
    gameAttributes: "Game Attributes"
    addAttribute: "Add Attribute"
    close: "Close"
    home: "Home"
    guest: "Guest"
    matchday: "Matchday"
    result: "Result"
    rank: "Rank"
    goals: "Goals"
    goalsAgainst: "Goals Against"
    difference: "Difference"
    points: "Points"
        roundItemNotAddable: "Die Gruppe/Das Spiel kann nicht hinzugefügt werden, weil bereits eine nächste Turnierrunde existiert."
            lastRoundNotValid: "Die letzte Runde ist nocht nicht valide. Entweder sind noch nicht alle Qualifikanten der vorletzten Runde übernommen worden, oder die Anzahl der Qualifikanten der letzten Runde ist kleiner als zwei."