moment = require 'moment'

module.exports =

  show: "Betrachten"
  edit: "Bearbeiten"
  add: "Hinzufügen"
  save: "Speichern"
  saved: "Gespeichert"
  delete: "Löschen"
  copied: "Kopie"
  create: "Erstellen"
  created: "Erstellt"
  duplicate: "Kopieren"
  error: "Fehler"
  warning: "Warnung"
  open: "Öffnen"
  contact: "Kontakt"
  datum: "Datum"
  time: "Zeit"
  contactUs: "Kontakt"
  favorites: "Favoriten"
  profile: "Profil"
  language: "Sprache"
  german: "Deutsch"
  english: "Englisch"
  createIn3Minutes: "Erstell dein Turnier in 3 Minuten"

  sports: "Sportart"
  football: "Fußball"
  volleyball: "Volleyball"
  other: "Andere"

  date: (date) ->
    moment.lang 'de'
    moment(date).fromNow()

  parseAndPrintDate: (date) ->
    moment.lang 'de'
    if date
      moment(date, "DD.MM.YYYY").format "dddd, DD. MMMM YYYY"

  ################################ COMMON ########################################################
  createNewTournament: "Neues Turnier erstellen"
  newTournament: "Neues Turnier"
  tournamentName: "Turniername"
  noTournamentsCreated: "Momentan hast Du noch kein Turnier erstellt."
  noTournamentsInFavorites: "Momentan hast Du noch kein Turnier zu deinen Favoriten hinzugefügt."
  guest: "Gast"
  tournamentLeader: "Turnierleiter"


  infoAlert:
    members: "Verwalte die Teilnehmer/Mannschaften deines Turnieres. Füge ihnen flexibel Attribute hinzu."
    info: "Verwalte die Basisdaten und Einstellungen deines Turnieres hier"
    tree: """
      Erstelle Dir einen kompletten Turnierbaum und pflege die Ergebnisse Deines Turniers ein. Gruppenphasen und KO-Runden lassen sich beliebig kombinieren.
      """
    gallery: "Stelle bis zu 20 Bilder in die turniereigene Bildergallerie ein."


  ################################ LOGIN ########################################################
  register: "Registrieren"
  userAlreadyExists: "Ein Nutzer mit dieser Email-Adresse existiert bereits."
  passwordSent: "Dein Passwort wurde dir zugesandt."
  password: "Passwort"#
  lostPassword: "Passwort vergessen"
  requestPassword: "Passwort anfordern"
  myTournaments: "Meine Turniere"
  tournaments: "Turniere"
  changePassword: "Passwort ändern"
  currentPassword: "Aktuelles Passwort"
  newPassword: "Neues Passwort"
  newPasswordRepeat: "Neues Passwort wiederholen"


  ################################ GALLERY ########################################################
  gallery:
    navName: "Gallerie"
    addImages: "Bilder hinzufügen"
    delete: "Löschen"
    title: "Titel"

  ################################ INFO ########################################################
  info:
    header: "Turnierinformation"
    navName: "Info"
    description: "Beschreibung"
    venue: "Ort"
    when: "Beginn"
    startDate: "Beginn"
    stopDate: "Ende"
    host: "Veranstalter"
    basicData: "Basisdaten"
    stopTimeKnown: "Endzeit bekannt?"
    deleteStopTime: "Endzeit löschen"
    publicName: "Öffentlicher Turniername"
    save: "Speichern"
    preview: "Vorschau"

  chat:
    delete: "Löschen"
    message: "Schreibe eine Nachricht"
    messageStream: "Nachrichten"
    publish: "Veröffentlichen"
    showMore: "Mehr Anzeigen"
    tournamentCreated: "Turnier erstellt."

  ################################ SETTINGS ########################################################

  settings:
    header: "Turnier-Einstellungen"
    navName: "Einstellungen"
    publicName: "Öffentlicher Turniername"
    logo: "Turnier Logo"
    save: "Speichern"
    applyColor: "Farben anwenden"
    color: "Farbe"
    colorSelection: "Farbauswahl"
    background: "Hintergrund"
    content: "Inhaltsbereich"
    contentText: "Text im Inhaltsbereich"
    footer: "Footer"
    footerText: "Text im Footer"
    publicNameInfo: "Der öffentlicher Turniername dient zum Zugriff auf das Turnier über die URL-Adresse."
    publicNameExample: "Beispiel: http://minja.net/minjacup"
    publicNameRestriction: "Der Name unterliegt folgenden Einschränkungen:"
    publicNameRestriction1: "mindestens 5 Zeichen"
    publicNameRestriction2: "nur Buchstaben, Zahlen oder Punkt"
    publicNameRestriction3: "darf nicht vergeben sein"
    theme: "Theme"
    selectTheme: "vordefiniertes Theme auswählen"
    saveLogo: "Logo speichern"
    deleteLogo: "Logo löschen"
    uploadLogo: "Turnierlogo hochladen"
    choosePicture: "Bild auswählen"
    editLogo: "Turnier Logo bearbeiten"

  ################################ MEMBERS ########################################################
  members:
    navName: "Teilnehmer"
    addAttribute: "Attribut hinzufügen"
    attribute: "Attribut"
    member: "Teilnehmer"
    visibility: "Sichtbarkeit"
    type: "Typ"
    textfield: "Textfeld"
    noMembersCreated: "Es wurden noch keine Teilnehmer erfasst."


  ################################ TREE ########################################################
  tree:
    navName: "Turnierbaum"
    groupStage: "Gruppenphase"
    koRound: "KO-Runde"
    addKoRound: "neue KO-Runde hinzufügen"
    addGroupStage: "neue Gruppenphase hinzufügen"
    previousRound: "Letzte Runde"
    deletePreviousRound: "Letzte Runde löschen"
    deletePreviousRoundInfo: "Wenn du die letzte Runde löscht, gehen alle Spiele und Ergebnisse dieser Runde verloren. Bist du dir sicher?"
    group: "Gruppe"
    game: "Spiel"
    remove: "Löschen"
    groupSizeUp: "Gruppengröße erhöhen"
    groupSizeDown: "Gruppengröße verringern"
    qualifiersUp: "Qualifikantenanzahl erhöhen"
    qualifiersDown: "Qualifikantenanzahl verringern"
    games: "Spiele"
    gamesPerMatch: "Spiele/Begegnung"
    winner: "Sieger"
    player: "Spieler"
    edit: "Bearbeiten"
    qualifiers: "Qualifikanten"
    schedule: "Spielplan"
    table: "Tabelle"
    detailView: "Detailansicht"
    settings: "Einstellungen"
    actions: "Aktionen"
    save: "Speichern"
    saved: "Gespeichert"
    pointsModus: "Punkte/Modus"
    pointsPerWin: "Punkte/Sieg"
    pointsPerDraw: "Punkte/Unentschieden"
    timePerGame: "Minuten/Spiel"
    gameAttributes: "Spielmerkmale"
    addAttribute: "Merkmal hinzufügen"
    timeCalculation: "Zeitplanung"
    close: "Schließen"
    all: "Alle"
    open: "Offene Spiele"
    played: "Gespielte Spiele"
    shuffle: "Auslosen"
    shufflePlayers: "Runde auslosen"
    shufflePlayersDescription: "Wenn du diese Runde neu auslost, werden alle Spiele dieser Runde zurückgesetzt"
    home: "Heim"
    guest: "Gast"
    matchday: "Spieltag"
    result: "Ergebnis"
    rank: "Rang"
    wins: "Siege"
    winsShort: "S"
    draws: "Unentschieden"
    drawsShort: "U"
    defeats: "Niederlagen"
    defeatsShort: "N"
    goals: "Tore"
    goalsShort: "T"
    goalsAgainst: "Gegentore"
    goalsAgainstShort: "G"
    difference: "Differenz"
    points: "Punkte"
    swapPlayers: "Wechseln"
    sets: "Sätze"
    textfield: "Textfeld"
    date: "Datum"
    number: "Nummer"
    roundItemNotAddable: "Die Gruppe/Das Spiel kann nicht hinzugefügt werden, weil bereits eine nächste Turnierrunde existiert."
    lastRoundNotValid: "Die letzte Runde ist nocht nicht valide. Entweder sind noch nicht alle Qualifikanten der vorletzten Runde übernommen worden, oder die Anzahl der Qualifikanten der letzten Runde ist kleiner als zwei."
    gamesParallel: "Spiele parallel"
    deleteGameAttribute: "Merkmal löschen"
    reallyDeleteGameAttribute: "Wenn Sie das Merkmal löschen, werden alle dazugehörigen Werte der Spiele gelöscht. Wirklich löschen?"
    unsavedChanges: "Es liegen noch ungespeicherte Änderungen vor!"

  ################################ POPUP ########################################################
  popup:
    yes: "Ja"
    no: "Nein"
    question: "Frage"
    cancel: "Abbrechen"
