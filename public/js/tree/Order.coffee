root = "public/js/tree/"

treeFiles  = [
  # omit src/ and .coffee to make the below lines a little shorter
  'App.coffee'
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
  'view/TournamentView.coffee'
  'view/RoundItemView.coffee'
  'view/RoundSettingView.coffee'
  'view/RoundView.coffee'
  'view/GroupRoundView.coffee'
  'view/GroupView.coffee'
  'view/GameView.coffee'
  'view/helper/NumberField.coffee'
  'view/helper/DynamicTypeAheadTextField.coffee'
  'view/helper/Alert.coffee'
  'view/detailViews/DetailView.coffee'
  'view/detailViews/GamesDetailView.coffee'
  'view/detailViews/RoundDetailView.coffee'
  'view/detailViews/RoundItemDetailView.coffee'
  'view/detailViews/helper/GameAttributeValueView.coffee'
  'view/detailViews/helper/GameAttributePrefillPopup.coffee'
  'view/TournamentSettings.coffee'
  'utils/Utils.coffee'
  'utils/PersistanceManager.coffee'
  'utils/RoundRobin.coffee'
]

module.exports = treeFiles.map (name) -> root + name
