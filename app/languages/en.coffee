moment = require 'moment'

module.exports =
  lang: 'en'

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
  profile: "Profile"
  language: "Language"
  german: "German"
  english: "English"
  createIn3Minutes: "create your tournament in 3 minutes"

  sports: "Sports"
  football: "Football"
  volleyball: "Volleyball"
  other: "Other"

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
    members: """
      Manage the participants of Your tournament. Feel free to add additional attributes e.g., "email", "member count"
    """
    info: "Manage basic data of Your tournament."
    tree: """
      Create a complete tournament bracket. Combine group stages and knockout phases in any order.
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
    description: "Details"
    venue: "Location"
    when: "When"
    startDate: "From"
    stopDate: "To"
    host: "Host"
    basicData: "Basic Data"
    stopTimeKnown: "End Time?"
    deleteStopTime: "Delete End Time"
    publicName: "Public Tournament Name"
    save: "Save"
    available: "available"
    notAvailable: "not available"
    preview: "Preview"

  chat:
    delete: "Delete"
    messageStream: "Message Stream"
    publish: "Publish"
    message: "Write a Message"
    showMore: "Show More"
    tournamentCreated: "Tournament created."


  ################################ SETTINGS ########################################################

  settings:
    header: "Tournament Settings"
    navName: "Settings"
    publicName: "Public Tournament Name"
    logo: "Logo"
    save: "Save"
    applyColor: "Apply Color"
    color: "Color"
    colorSelection: "Color Selection"
    background: "Background"
    content: "Contentarea"
    contentText: "Text in Contentarea"
    footer: "Menu"
    footerText: "Text in Menu"
    publicNameInfo: "The public tournament name is used to build a tiny url. That provides short aliases for redirection of long URLs."
    publicNameExample: "Example: http://minja.net/minjacup"
    publicNameRestriction: "The name is restricted as follows:"
    publicNameRestriction1: "at least 5 characters"
    publicNameRestriction2: "letters, numbers and dots are allowed"
    publicNameRestriction3: "may not be assigned to another tournament"
    theme: "Theme"
    selectTheme: "Select predefined theme"
    saveLogo: "Save Logo"
    deleteLogo: "Delete Logo"
    uploadLogo: "Upload custom Logo"
    uploadLogoInfo: "In order to achieve an appealing appearance, we recommend the use of a transparent background."
    choosePicture: "Choose image"
    editLogo: "Edit Tournament Logo"

################################ MEMBERS ########################################################
  members:
    navName: "Participants"
    addAttribute: "Add Attribute"
    attribute: "Attribute"
    member: "Participant"
    visibility: "Visibility"
    type: "Type"
    textfield: "Textfield"
    notRecordedYet: "no participants recorded yet"
    playerDoPartipate: "is included in bracket"


################################ TREE ########################################################
  bracket:
    navName: "Bracket"
    notRecordedYet: "no tournament bracket created yet"
    groupStage: "Group Stage"
    koRound: "Knockout Phase"
    addKoRound: "Add Knockout Phase"
    addGroupStage: "Add Group Stage"
    group: "Group"
    previousRound: "Previous Round"
    deletePreviousRound: "Remove Previous Round"
    deletePreviousRoundInfo: "Remove previous round will cause a deletion of its game results. Are you sure?"
    game: "Game"
    games: "Games"
    gamesPerMatch: "Games/Match"
    remove: "Remove"
    groupSizeUp: "Increase Groupsize"
    groupSizeDown: "Decrease Groupsize"
    qualifiersUp: "Increase Qualifiercount"
    qualifiersDown: "Decrease Qualifiercount"
    winner: "Winner"
    player: "Player"
    edit: "Edit"
    qualifiers: "Qualifiers"
    schedule: "Schedule"
    table: "Standings"
    detailView: "Detail View"
    settings: "Settings"
    actions: "Actions"
    save: "Save"
    saved: "Saved"
    statistic: "Statistics"
    pointsModus: "Points/Modus"
    pointsPerWin: "Points/Win"
    pointsPerDraw: "Points/Draw"
    timePerGame: "Minutes/Game"
    gameAttributes: "Game Attributes"
    addAttribute: "Add Attribute"
    timeCalculation: "Scheduling"
    close: "Close"
    all: "All"
    open: "Open games"
    played: "Played games"
    shuffle: "Shuffle"
    shufflePlayers: "Shuffle players"
    shufflePlayersDescription: "Shuffle players will reset the game results of this round."
    home: "Home"
    guest: "Guest"
    matchday: "Matchday"
    result: "Result"
    rank: "Rank"
    wins: "Wins"
    winsShort: "W"
    draws: "Draws"
    drawsShort: "D"
    defeats: "Losses"
    defeatsShort: "L"
    goals: "Goals"
    goalsShort: "G"
    goalsAgainst: "Goals Against"
    goalsAgainstShort: "A"
    difference: "Goal Difference"
    points: "Points"
    swapPlayers: "Exchange"
    textfield: "Textfield"
    date: "Date"
    number: "Number"
    roundItemNotAddable: "The Group/Game is not addable, since a next tournament round already exists."
    lastRoundNotValid: "Last round is not valid."
    gamesParallel: "Games Parallel"
    deleteGameAttribute: "Delete Attribute"
    reallyDeleteGameAttribute: "If You delete this attribute, all game values refering to that attribute will be deleted too. Are you sure?"
    unsavedChanges: "You have unsaved changes!"

  ################################ POPUP ########################################################
  popup:
    yes: "Yes"
    no: "No"
    question: "Question"
    cancel: "Cancel"
