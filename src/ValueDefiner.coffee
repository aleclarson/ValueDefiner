
{ Void
  setType
  setKind
  assertType
  validateTypes } = require "type-utils"

{ throwFailure } = require "failure"

NamedFunction = require "NamedFunction"
emptyFunction = require "emptyFunction"
combine = require "combine"
define = require "define"
isDev = require "isDev"
guard = require "guard"
sync = require "sync"

ValueCreator = require "./ValueCreator"

module.exports =
ValueDefiner = NamedFunction "ValueDefiner", (classConfig, options) ->

  assertType classConfig, Object
  validateTypes options,
    valueCreatorTypes: Object
    defineValues: [ Function, Void ]
    didDefineValues: [ Function, Void ]

  valueCreators = {}
  sync.each options.valueCreatorTypes, (ValueCreator, key) ->
    valueCreator = ValueCreator classConfig, key
    valueCreators[key] = valueCreator if valueCreator

  options.defineValues ?= (valueConfigs) ->
    define this, valueConfigs

  definer = (instance, args) ->
    definedValues = {} if options.didDefineValues
    sync.each valueCreators, (createValues, key) ->
      guard ->
        valueConfigs = createValues instance, args
        return unless valueConfigs
        assertType valueConfigs, Object
        if options.didDefineValues
          sync.each valueConfigs, (config, key) ->
            definedValues[key] = combine {}, config
        options.defineValues.call instance, valueConfigs, key, options.valueCreatorTypes[key]
      .fail (error) -> throwFailure error, { key }
    options.didDefineValues?.call instance, definedValues
    instance

  setType definer, ValueDefiner

setKind ValueDefiner, Function
