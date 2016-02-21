
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
  definers = sync.map types, (createDefiner) ->
    createDefiner config
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
      try
        values = initValues.apply instance, args
        values = combine.apply null, values if isType values, Array
        assertReturnType values, Object, { method: key, instance, args }
        values = transform values
        define instance, ->
          @options = options
          @ values
      catch error
        reportFailure error, { method: "#{instance.constructor.name}.#{key}", instance, args }

ValueDefiner.types = []

ValueDefiner.createType = (config) ->
  type = ValueDefiner.Type config
  ValueDefiner.types.push type
  return

ValueDefiner.createType
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

ValueDefiner.createType
  key: "customValues"
  init: (values) ->
    return unless isType values, Object
    for key, value of values
      assertType value, Object
      value.enumerable = key[0] isnt "_"
    return -> values

ValueDefiner.createType
  key: "initFrozenValues"
  options: { frozen: yes }
  transform: (values) ->
    sync.map values, (value, key) -> {
      value
      enumerable: key[0] isnt "_"
    }


ValueDefiner.createType
  key: "initValues"
  options: { configurable: no }
  transform: (values) ->
    sync.map values, (value, key) -> {
      value
      enumerable: key[0] isnt "_"
    }

ValueDefiner.createType
  key: "initReactiveValues"
  options: { reactive: yes, configurable: no }
  transform: (values) ->
    sync.map values, (value, key) -> {
      value
      enumerable: key[0] isnt "_"
    }
