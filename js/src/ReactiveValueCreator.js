var ValueCreator, sync;

sync = require("sync");

ValueCreator = require("./ValueCreator");

module.exports = ValueCreator("ReactiveValueCreator", {
  transform: function(values) {
    return sync.map(values, function(value, key) {
      return {
        value: value,
        reactive: true
      };
    });
  }
});

//# sourceMappingURL=../../map/src/ReactiveValueCreator.map
