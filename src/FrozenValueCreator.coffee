
sync = require "sync"

ValueCreator = require "./ValueCreator"

module.exports = ValueCreator "FrozenValueCreator",

  transform: (values) ->
    sync.map values, (value, key) ->
      { value, frozen: yes }
