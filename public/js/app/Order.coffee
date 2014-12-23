_ = require 'underscore'

bracketRoot = "public/js/app/bracket/"
appRoot = "public/js/app/"

appFiles = [
  'routes.coffee'
  'bracket/BracketRoute.coffee'
  'utils/DynamicTextField.coffee'
  'utils/DynamicTypeAheadTextField.coffee'
  'utils/NumberSpinner.coffee'
  'utils/EmberSerializer.coffee'
  'application/ApplicationRoute.coffee'
  'application/ApplicationController.coffee'
  'info/InfoRoute.coffee'
  'info/InfoView.coffee'
  'settings/SettingsRoute.coffee'
  'settings/SettingsController.coffee'
  'settings/SettingsView.coffee'
  'dashboard/DashboardView.coffee'
  'dashboard/DashboardRoute.coffee'
  'dashboard/DashboardController.coffee'
  'participants/ParticipantsRoute.coffee'
  'participants/ParticipantsController.coffee'
  'participants/ParticipantsView.coffee'
]

bracketFiles  = [
  'model/tournament.coffee'
  'model/round.coffee'
  'model/koRound.coffee'
  'model/groupRound.coffee'
  'model/roundItem.coffee'
  'model/group.coffee'
  'model/roundGame.coffee'
  'model/game.coffee'
  'model/gameAttribute.coffee'
  'model/player.coffee'
  'model/playerAttribute.coffee'
  'model/playerPool.coffee'
  'view/TournamentView.coffee'
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
  'view/TournamentSettings.coffee'
  'components/IconButtonComponent.coffee'
  'components/PlayerLinkComponent.coffee'
  'utils/Utils.coffee'
  'utils/Observer.coffee'
  'utils/PersistanceManager.coffee'
  'utils/RoundRobin.coffee'
  'utils/BracketLineDrawer.coffee'
]

wrapperTop = """
  define([
    "utils/Popup",\n
    "typeahead"], function(Popup) {\n
"""

wrapperBottom = """
    App.Popup = Popup;\n
    });\n
"""

module.exports =
  files: [appRoot + 'App.coffee'].concat (bracketFiles.map((n) -> bracketRoot + n)).concat(appFiles.map((name) -> appRoot + name))
  wrapperTop: wrapperTop
  wrapperBottom: wrapperBottom
