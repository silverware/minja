schemaUtils = require './schemaUtils'
_ = require 'underscore'

qualifierModi =
  aggregate: "aggregate"
  bestof: "bestof"

sportSchema =
  title: 'Message'
  type: 'object'
  properties:
    sport_id:
      type: 'string'
    pointsPerWin:
      type: 'integer'
      minimum: 0
      default: 0
    pointsPerDraw:
      type: 'integer'
      minimum: 0
      default: 0
    # key of pointsLabel: eg. points, sets, ...
    pointsLabel:
      type: 'string'
    qualifierModus:
      enum: [qualifierModi.aggregate, qualifierModi.bestof]
  required: ['sport_id']

exports =
  qualifierModi: qualifierModi
  schema: sportSchema

module.exports = _.extend exports, schemaUtils
