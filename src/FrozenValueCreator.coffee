
{ sync } = require "io"

ValueCreator = require "./ValueCreator"

module.exports = ValueCreator "FrozenValueCreator",

  transform: (values) ->
    sync.map values, (value, key) -> {
      value
      frozen: yes
      enumerable: key[0] isnt "_"
    }
