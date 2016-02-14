
require "lotus-require"

{ Void
  isType
  assertType
  validateTypes
  assertReturnType } = require "type-utils"

{ sync } = require "io"

emptyFunction = require "emptyFunction"
combine = require "combine"
define = require "define"
steal = require "steal"

module.exports =
ValueDefiner = (config, types) ->
  definers = sync.map types, (ValueDefinerType) ->
    ValueDefinerType config
  return (instance, args) ->
    for definer in definers
      definer instance, args
    instance

ValueDefiner.Type = (config) ->

  validateTypes config,
    key: String
    options: Object
    init: [ Function, Void ]
    transform: [ Function, Void ]

  { key, options, init, transform } = config

  init ?= emptyFunction.thatReturnsArgument
  transform ?= emptyFunction.thatReturnsArgument

  return (config) ->
    initValues = init steal config, key
    return emptyFunction unless initValues?
    assertType initValues, Function
    return (instance, args) ->
      values = initValues.apply instance, args
      values = combine.apply null, values if isType values, Array
      assertReturnType values, Object, { key }
      values = transform values
      define instance, ->
        @options = options
        @ values

ValueDefiner.types = [

  ValueDefiner.Type
    key: "boundMethods"
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

  ValueDefiner.Type
    key: "customValues"
    init: (values) ->
      return unless isType values, Object
      for key, value of values
        assertType value, Object
        value.enumerable = key[0] isnt "_"
      return -> values

  ValueDefiner.Type
    key: "initFrozenValues"
    options: { frozen: yes }
    transform: (values) ->
      sync.map values, (value, key) -> {
        value
        enumerable: key[0] isnt "_"
      }


  ValueDefiner.Type
    key: "initValues"
    options: { configurable: no }
    transform: (values) ->
      sync.map values, (value, key) -> {
        value
        enumerable: key[0] isnt "_"
      }

  ValueDefiner.Type
    key: "initReactiveValues"
    options: { reactive: yes, configurable: no }
    transform: (values) ->
      sync.map values, (value, key) -> {
        value
        enumerable: key[0] isnt "_"
      }
]
