class Sport extends require './mixIn'
  sport_id: ""
  pointsPerWin: 0
  pointsPerDraw: 0
  # key of pointsLabel: eg. points, sets, ...
  pointsLabel: ""
  # [aggregate, bestof]
  qualifierModus: ""

module.exports = Sport
