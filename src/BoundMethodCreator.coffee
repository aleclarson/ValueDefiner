
{ isType, assertType } = require "type-utils"

sync = require "sync"

ValueCreator = require "./ValueCreator"

module.exports = ValueCreator "BoundMethodCreator",

  init: (keys) ->

    return unless isType keys, Array

    return ->

      boundMethods = {}

      sync.each keys, (key) =>

        method = this[key]

        assertType method, Function,
          key: @constructor.name + "." + key
          instance: this

        boundMethods[key] =
          value: => method.apply this, arguments

      boundMethods
