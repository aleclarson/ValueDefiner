var ValueCreator, sync;

sync = require("sync");

ValueCreator = require("./ValueCreator");

module.exports = ValueCreator("WritableValueCreator", {
  transform: function(values) {
    return sync.map(values, function(value) {
      return {
        value: value
      };
    });
  }
});

//# sourceMappingURL=../../map/src/WritableValueCreator.map
