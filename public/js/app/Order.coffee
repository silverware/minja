bracketRoot = "public/js/app/bracket/"
appRoot = "public/js/app/"

appFiles = [
  'App.coffee'
  'routes.coffee'
  'bracket/BracketRoute.coffee'
  'application/ApplicationRoute.coffee'
  'application/ApplicationController.coffee'
  'info/InfoRoute.coffee'
  'info/InfoView.coffee'
  'settings/SettingsRoute.coffee'
  'settings/SettingsView.coffee'
  'participants/ParticipantsRoute.coffee'
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
  define(["utils/DynamicTextField",\n
    "utils/EmberSerializer",\n
    "utils/Popup",\n
    "typeahead"], function(dynamicTextField, Serializer, Popup) {\n
"""

wrapperBottom = """
    App.DynamicTextField = dynamicTextField;\n
    App.Serializer = Serializer;\n
    App.Popup = Popup;\n
    });\n
"""

module.exports =
  files: treeFiles.map (name) -> root + name
  wrapperTop: wrapperTop
  wrapperBottom: wrapperBottom
