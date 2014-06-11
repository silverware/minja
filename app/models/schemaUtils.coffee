_ = require 'underscore'
tv4 = require 'tv4'

createFromSchema = (schema) ->
  switch schema.type
    when 'boolean'
      return schema.default or true
    when 'integer'
      return schema.default or 0
    when 'number'
      return schema.default or 0
    when 'string'
      return schema.default or ""
    when 'array'
      return []
      obj[key] = createFromSchema schema
    when 'object'
      obj = {}
      for key, value of schema.properties
        obj[key] = createFromSchema value
      return obj

module.exports =
  create: (data) ->
    _.extend createFromSchema(@schema), data
  validate: (obj) ->
    tv4.validate obj, @schema
