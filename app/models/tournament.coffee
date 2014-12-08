schemaUtils = require './schemaUtils'
_ = require 'underscore'

tournamentSchema =
  title: 'Tournament'
  type: 'object'
  definitions:
    member:
      type: 'object'
      properties:
        id:
          type: 'string'
        name:
          type: 'string'
        isDummy:
          type: 'boolean'
        isPlayer:
          type: 'boolean'
        attributes:
          type: 'object'
        isPrivate:
          type: 'boolean'
      required: ['id', 'name']

    memberAttribute:
      type: 'object'
      properties:
        id:
          type: 'string'
        name:
          type: 'string'
          pattern: schemaUtils.notBlank
        isPrivate:
          type: 'boolean'
        type:
          enum: ['textfield', 'checkbox']
      required: ['id', 'type', 'name']

    gameAttribute:
      type: 'object'
      properties:
        id:
          type: 'string'
        name:
          type: 'string'
          pattern: schemaUtils.notBlank
        type:
          enum: ['textfield', 'checkbox']
      required: ['id', 'type', 'name']

  required: ['user_id']

  properties:
    pulicName:
      type: 'string'
    user_id:
      type: 'string'
    created_at:
      type: 'string'
    sport_id:
      type: 'string'
    info:
      type: 'object'
      properties:
        name:
          type: 'string'
        description:
          type: 'string'
        venue:
          type: 'string'
        startDate:
          type: 'string'
        startTime:
          type: 'string'
        host:
          type: 'string'
        hostMail:
          type: 'string'
          format: 'email'
      required: ['name']
    members:
      type: 'object'
      properties:
        members:
          type: 'array'
          items:
            '$ref': 'member'
        membersAttributes:
          type: 'array'
          items:
            '$ref': 'memberAttribute'

    tree:
      type: 'object'
      properties:
        winPoints:
          type: 'integer'
        drawPoints:
          type: 'integer'
        timePerGame:
          type: 'integer'
        gamesParallel:
          type: 'integer'
        qualifierModus:
          type:
            enum: ['aggregate', 'bestof']
        gameAttributes:
          type: 'array'
          items:
            '$ref': 'gameAttribute'
    colors:
      type: 'object'
      properties:
        default:
          type: 'boolean'

module.exports = _.extend schema: tournamentSchema, schemaUtils
