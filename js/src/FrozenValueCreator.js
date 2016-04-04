var ValueCreator, sync;

sync = require("sync");

ValueCreator = require("./ValueCreator");

module.exports = ValueCreator("FrozenValueCreator", {
  transform: function(values) {
    return sync.map(values, function(value, key) {
      return {
        value: value,
        frozen: true
      };
    });
  }
});

//# sourceMappingURL=../../map/src/FrozenValueCreator.map
