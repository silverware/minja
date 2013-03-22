module.exports = class MixIn
  constructor: (initialData) ->
  	@[name] = method for name, method of initialData 