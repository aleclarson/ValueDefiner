
sync = require "sync"

ValueCreator = require "./ValueCreator"

module.exports = ValueCreator "WritableValueCreator",

  transform: (values) ->
    sync.map values, (value) -> { value }
