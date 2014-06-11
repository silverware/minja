schemaUtils = require './schemaUtils'
_ = require 'underscore'

authorTypes =
  leader: "leader"
  guest: "guest"

messageSchema =
  title: 'Message'
  type: 'object'
  properties:
    tournament_id:
      type: 'string'
    author:
      type: 'string'
    authorType:
      enum: [authorTypes.leader, authorTypes.guest]
    text:
      type: 'string'
  required: ['email']

module.exports = _.extend schema: messageSchema, schemaUtils
