App.Serializer =
  emberObjToJsonData: (obj) ->
    unless obj instanceof Ember.Object
      throw TypeError "argument is not an Ember Object"
    jsonObj = {}
    emberObj = Ember.ArrayController.create(content: [])
    if obj instanceof App.KoRound
      console.debug obj
    for key, value of obj
      continue if Ember.typeOf(value) == 'function'
      continue if emberObj[key] isnt undefined
      continue if value is 'toString'
      continue if value is undefined
      continue if /^_/.test key
      if value instanceof Em.ArrayController
        jsonObj[key] = @emberObjArrToJsonDataArr(value.content)
      else if typeof(value) == 'object' and value instanceof Array
        jsonObj[key] = @emberObjArrToJsonDataArr(value)
      else
        jsonObj[key] = value
    jsonObj

  toJsonData: ->
    # mixin method for Ember objects
    @emberObjToJsonData @

  emberObjArrToJsonDataArr: (objArray) ->
    @emberObjToJsonData obj for obj in objArray

  controllerToJson: (controller) ->
    @emberObjArrToJsonDataArr controller.content

  toJsonDataArray: (arrayProperty) ->
    # mixin method for Ember objects
    @emberObjArrToJsonDataArr @get arrayProperty

  dataArrayToEmberObjArray: (EmberClass, dataArray) ->
    EmberClass.create obj for obj in dataArray
