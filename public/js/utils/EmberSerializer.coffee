define ->
  serialize =
    emberObjToJsonData: (obj) ->
      unless obj instanceof Ember.Object
        throw TypeError "argument is not an Ember Object"
      jsonObj = {}
      emberObj = Ember.ArrayController.create(content: [])
      for key, value of obj
        continue if Ember.typeOf(value) == 'function'
        continue if emberObj[key] != undefined
        continue if value == 'toString'
        continue if value == undefined
        continue if /^_/.test key
        if value instanceof Em.ArrayController
          jsonObj[key] = serialize.emberObjArrToJsonDataArr(value.content)
        else if typeof(value) == 'object' and value instanceof Array
          jsonObj[key] = serialize.emberObjArrToJsonDataArr(value)
        else
          jsonObj[key] = value
      jsonObj

    toJsonData: ->
      # mixin method for Ember objects
      serialize.emberObjToJsonData @

    emberObjArrToJsonDataArr: (objArray) ->
      serialize.emberObjToJsonData obj for obj in objArray

    controllerToJson: (controller) ->
      serialize.emberObjArrToJsonDataArr controller.content

    toJsonDataArray: (arrayProperty) ->
      # mixin method for Ember objects
      serialize.emberObjArrToJsonDataArr @get arrayProperty

    dataArrayToEmberObjArray: (EmberClass, dataArray) ->
      EmberClass.create obj for obj in dataArray
