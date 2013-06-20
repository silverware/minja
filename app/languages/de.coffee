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
      Erstell dir den kompletten Turnierbaum und pflege die Ergebnisse deines Turnieres ein.
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
    header: "Tournament Settings"
    navName: "Settings"
    publicName: "Public Tournament Name"
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


  ################################ MEMBERS ########################################################
  members:
    navName: "Teilnehmer"
    addAttribute: "Attribut hinzufügen"
    attribute: "Attribut"
    member: "Teilnehmer"
    visibility: "Sichtbarkeit"
    type: "Typ"
    textfield: "Textfeld"


  ################################ TREE ########################################################
  tree:
    navName: "Turnierbaum"
    groupStage: "Gruppenphase"
    koRound: "KO-Runde"
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
    winner: "Sieger"
    player: "Spieler"
    edit: "Bearbeiten"
    qualifiers: "Qualifikanten"
    schedule: "Spielplan"
    table: "Tabelle"
    detailView: "Detailansicht"
    settings: "Einstellungen"
    save: "Speichern"
    saved: "Gespeichert"
    pointsPerWin: "Punkte/Sieg"
    pointsPerDraw: "Punkte/Unentschieden"
    timePerGame: "Minuten/Spiel"
    gameAttributes: "Spielmerkmale"
    addAttribute: "Merkmal hinzufügen"
    close: "Schließen"
    shuffle: "Mischen"
    shufflePlayers: "Runde auslosen"
    shufflePlayersDescription: "Wenn du diese Runde neu auslost, werden alle Spiele dieser Runde zurückgesetzt"
    home: "Heim"
    guest: "Gast"
    matchday: "Spieltag"
    result: "Ergebnis"
    rank: "Rang"
    goals: "Tore"
    goalsAgainst: "Gegentore"
    difference: "Differenz"
    points: "Punkte"
    sets: "Sätze"
    roundItemNotAddable: "Die Gruppe/Das Spiel kann nicht hinzugefügt werden, weil bereits eine nächste Turnierrunde existiert."
    lastRoundNotValid: "Die letzte Runde ist nocht nicht valide. Entweder sind noch nicht alle Qualifikanten der vorletzten Runde übernommen worden, oder die Anzahl der Qualifikanten der letzten Runde ist kleiner als zwei."
    gamesParallel: "Spiele parallel"
    reallyDeleteGameAttribute: "Wenn Sie das Merkmal löschen, werden alle dazugehörigen Werte der Spiele gelöscht. Wirklich löschen?"

  ################################ POPUP ########################################################
  popup:
    yes: "Ja"
    no: "Nein"
    question: "Frage"
    cancel: "Abbrechen"
