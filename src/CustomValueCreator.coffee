
{ isType
  assertType } = require "type-utils"

sync = require "sync"

combine = require "combine"

ValueCreator = require "./ValueCreator"

module.exports = ValueCreator "CustomValueCreator",

  init: (reusedConfigs) ->

    return unless isType reusedConfigs, Object

    assertType config, Object for key, config of reusedConfigs

    # In case a `config` is overridden, keep `reusedConfigs` untouched.
    return -> combine {}, reusedConfigs
