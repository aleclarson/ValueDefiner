
sync = require "sync"

ValueCreator = require "./ValueCreator"

module.exports = ValueCreator "ReactiveValueCreator",

  transform: (values) ->
    sync.map values, (value, key) ->
      { value, reactive: yes }
