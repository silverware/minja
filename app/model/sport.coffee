class Sport extends require './MixIn'
  sport_id: ""
  pointsPerWin: 0
  pointsPerDraw: 0
  # key of pointsLabel: eg. points, sets, ...
  pointsLabel: ""
  # [aggregate, bestof]
  qualifierModus: ""

sports = [
  new Sport({sport_id: "football", pointsPerWin: 3, pointsPerDraw: 1, pointsLabel: "points", qualifierModus: "aggregate"}),
  new Sport({sport_id: "volleyball", pointsPerWin: 2, pointsPerDraw: 0, pointsLabel: "sets", qualifierModus: "bestOfX"})
]

module.exports = Sport