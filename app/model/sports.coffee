###
pointsLabel: key of pointsLabel: eg. points, sets, ... 
###

module.exports =

  volleyball: 
    pointsPerWin: 2
    pointsPerDraw: 1
    pointsLabel: "sets"
    # [aggregate, bestof]
    qualifierModus: "bestof"

  football: 
    pointsPerWin: 3
    pointsPerDraw: 1
    pointsLabel: "goals"
    # [aggregate, bestof]
    qualifierModus: "aggregate"
  
  other:
    pointsPerWin: 3
    pointsPerDraw: 1
    pointsLabel: "goals"
    # [aggregate, bestof]
    qualifierModus: "aggregate"