var ValueCreator, assertType, combine, isType, ref, sync;

ref = require("type-utils"), isType = ref.isType, assertType = ref.assertType;

sync = require("sync");

combine = require("combine");

ValueCreator = require("./ValueCreator");

module.exports = ValueCreator("CustomValueCreator", {
  init: function(reusedConfigs) {
    var config, key;
    if (!isType(reusedConfigs, Object)) {
      return;
    }
    for (key in reusedConfigs) {
      config = reusedConfigs[key];
      assertType(config, Object);
    }
    return function() {
      return combine({}, reusedConfigs);
    };
  }
});

//# sourceMappingURL=../../map/src/CustomValueCreator.map
