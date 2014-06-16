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
      required: ['id', 'name']
    memberAttribute:
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
    colors:
      type: 'object'
      properties:
        default:
          type: 'boolean'

module.exports = _.extend schema: tournamentSchema, schemaUtils
