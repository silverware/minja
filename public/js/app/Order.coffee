_ = require 'underscore'

bracketRoot = "public/js/app/bracket/"
appRoot = "public/js/app/"

appFiles = [
  'models/tournament.coffee'
  'models/bracket/bracket.coffee'
  'models/bracket/round.coffee'
  'models/bracket/koRound.coffee'
  'models/bracket/groupRound.coffee'
  'models/bracket/roundItem.coffee'
  'models/bracket/group.coffee'
  'models/bracket/roundGame.coffee'
  'models/bracket/game.coffee'
  'models/bracket/gameAttribute.coffee'
  'models/bracket/player.coffee'
  'models/bracket/playerAttribute.coffee'
  'models/participants.coffee'
  'models/info.coffee'
  'routes.coffee'
  'bracket/BracketRoute.coffee'
  'bracket/BracketController.coffee'
  'form/DynamicTextField.coffee'
  'form/SaveButtonComponent.coffee'
  'form/ColorSelectionTextFieldView.coffee'
  'form/DateTimeComponent.coffee'
  'form/DynamicTypeAheadTextField.coffee'
  'form/TypeAheadTextField.coffee'
  'form/NumberSpinner.coffee'
  'application/ApplicationRoute.coffee'
  'application/ApplicationController.coffee'
  'application/ApplicationView.coffee'
  'info/InfoRoute.coffee'
  'info/InfoController.coffee'
  'info/InfoView.coffee'
  'info/InfoEditView.coffee'
  'settings/SettingsRoute.coffee'
  'settings/SettingsController.coffee'
  'settings/SettingsView.coffee'
  'settings/ColorThemes.coffee'
  'settings/ColorSelectionPopup.coffee'
  'dashboard/DashboardView.coffee'
  'dashboard/BracketStatisticsView.coffee'
  'dashboard/DashboardRoute.coffee'
  'dashboard/DashboardController.coffee'
  'participants/ParticipantsRoute.coffee'
  'participants/ParticipantsController.coffee'
  'participants/ParticipantsView.coffee'
  'utils/EmberSerializer.coffee'
  'utils/Utils.coffee'
  'utils/Observer.coffee'
  'utils/PersistanceManager.coffee'
  'utils/RoundRobin.coffee'
  'utils/BracketLineDrawer.coffee'
  'components/EditLinkComponent.coffee'
  'components/IconButtonComponent.coffee'
  'components/PlayerLinkComponent.coffee'
  'components/FormGroupComponent.coffee'
  'components/PrettyDateTimeComponent.coffee'
  'components/InfoHintComponent.coffee'
  'components/MarkdownComponent.coffee'
]

bracketFiles  = [
  'view/BracketView.coffee'
  'view/RoundItemView.coffee'
  'view/RoundSettingView.coffee'
  'view/RoundView.coffee'
  'view/GroupRoundView.coffee'
  'view/GroupView.coffee'
  'view/GameView.coffee'
  'view/helper/NumberField.coffee'
  'view/helper/SearchTextField.coffee'
  'view/helper/FilterButton.coffee'
  'view/helper/DynamicTypeAheadTextField.coffee'
  'view/helper/Alert.coffee'
  'view/detailViews/DetailView.coffee'
  'view/detailViews/GamesDetailView.coffee'
  'view/detailViews/RoundDetailView.coffee'
  'view/detailViews/RoundItemDetailView.coffee'
  'view/detailViews/PlayerDetailView.coffee'
  'view/detailViews/helper/GameAttributeValueView.coffee'
  'view/detailViews/helper/GameAttributePrefillPopup.coffee'
  'view/TournamentSettingsView.coffee'
]

wrapperTop = """
  define([
    "utils/Popup",\n
    "typeahead", "marked"], function(Popup, type, marked) {\n
"""

wrapperBottom = """
    App.Popup = Popup;\n
    window.marked = marked;\n
    });\n
"""

module.exports =
  files: [appRoot + 'App.coffee'].concat (appFiles.map((name) -> appRoot + name)).concat(bracketFiles.map((n) -> bracketRoot + n))
  wrapperTop: wrapperTop
  wrapperBottom: wrapperBottom
