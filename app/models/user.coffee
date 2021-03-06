schemaUtils = require './schemaUtils'
_ = require 'underscore'

userSchema =
  title: 'User'
  type: 'object'
  properties:
    email:
      type: 'string'
      format: 'email'
      pattern: schemaUtils.notBlank
    password:
      type: 'string'
  required: ['email']

module.exports = _.extend schema: userSchema, schemaUtils
