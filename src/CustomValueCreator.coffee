
{ isType
  assertType } = require "type-utils"

{ sync } = require "io"

combine = require "combine"

ValueCreator = require "./ValueCreator"

module.exports = ValueCreator "CustomValueCreator",

  init: (reusedConfigs) ->
    return unless isType reusedConfigs, Object
    for key, config of reusedConfigs
      assertType config, Object
      config.enumerable = key[0] isnt "_"
      config.configurable ?= no
    return ->
      # In case a `config` is overridden, keep `reusedConfigs` untouched.
      combine {}, reusedConfigs
