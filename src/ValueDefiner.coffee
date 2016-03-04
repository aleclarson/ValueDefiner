
{ Void
  isType
  isKind
  setType
  setKind
  assertType
  assertKind
  validateTypes
  assertReturnType } = require "type-utils"

{ throwFailure } = require "failure"

{ sync } = require "io"

NamedFunction = require "named-function"
emptyFunction = require "emptyFunction"
combine = require "combine"
define = require "define"

ValueCreator = require "./ValueCreator"

module.exports =
ValueDefiner = NamedFunction "ValueDefiner", (classConfig, options) ->

  assertType classConfig, Object
  validateTypes options,
    valueCreatorTypes: Object
    defineValues: [ Function, Void ]
    didDefineValues: [ Function, Void ]

  { valueCreatorTypes, defineValues, didDefineValues } = options

  valueCreators = {}
  for key, initValueCreator of valueCreatorTypes
    assertKind initValueCreator, Function
    valueCreator = initValueCreator classConfig, key
    if isKind valueCreator, Function
      valueCreators[key] = valueCreator

  defineValues ?= (valueConfigs) ->
    define this, valueConfigs

  definer = (instance, args) ->
    definedValues = {} if didDefineValues?
    for key, createValues of valueCreators
      try
        valueConfigs = createValues instance, args
        if valueConfigs?
          assertType valueConfigs, Object
          if didDefineValues?
            for key, config of valueConfigs
              definedValues[key] = combine {}, config
          defineValues.call instance, valueConfigs, key, valueCreatorTypes[key]
      catch error
        throwFailure error, { key }
    didDefineValues?.call instance, definedValues
    instance

  setType definer, ValueDefiner

setKind ValueDefiner, Function
