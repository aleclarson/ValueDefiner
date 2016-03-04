
{ Void
  isType
  setType
  setKind
  assertType
  validateTypes
  assertReturnType } = require "type-utils"

NamedFunction = require "named-function"
emptyFunction = require "emptyFunction"
combine = require "combine"
steal = require "steal"

module.exports =
ValueCreator = NamedFunction "ValueCreator", (name, creatorConfig) ->

  assertType name, String
  validateTypes creatorConfig,
    init: [ Function, Void ]
    transform: [ Function, Void ]

  creatorConfig.init ?= emptyFunction.thatReturnsArgument
  creatorConfig.transform ?= emptyFunction.thatReturnsArgument

  factory = NamedFunction name, (options = {}) -> (classConfig, key) ->

    assertType classConfig, Object
    assertType key, String

    createValues = steal classConfig, key
    createValues = creatorConfig.init createValues, options
    return unless createValues?
    assertType createValues, Function

    creator = (instance, args) ->
      values = createValues.apply instance, args
      assertReturnType values, [ Object, Array ]
      values = combine.apply null, values if isType values, Array
      creatorConfig.transform values, options

    setType creator, factory

  setKind factory, ValueCreator

setKind ValueCreator, Function
