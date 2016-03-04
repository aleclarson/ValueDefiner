
{ isType, assertType } = require "type-utils"

ValueCreator = require "./ValueCreator"

module.exports = ValueCreator "BoundMethodCreator",

  init: (keys) ->
    return unless isType keys, Array
    return ->
      boundMethods = {}
      for key in keys
        method = this[key]
        assertType method, Function,
          key: @constructor.name + "." + key
          instance: this
        boundMethod = method.bind this
        boundMethod.toString = -> method.toString()
        boundMethods[key] =
          value: boundMethod
          enumerable: key[0] isnt "_"
      boundMethods
