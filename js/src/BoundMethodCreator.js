var ValueCreator, assertType, isType, ref, sync;

ref = require("type-utils"), isType = ref.isType, assertType = ref.assertType;

sync = require("sync");

ValueCreator = require("./ValueCreator");

module.exports = ValueCreator("BoundMethodCreator", {
  init: function(keys) {
    if (!isType(keys, Array)) {
      return;
    }
    return function() {
      var boundMethods;
      boundMethods = {};
      sync.each(keys, (function(_this) {
        return function(key) {
          var method;
          method = _this[key];
          assertType(method, Function, {
            key: _this.constructor.name + "." + key,
            instance: _this
          });
          return boundMethods[key] = {
            value: function() {
              return method.apply(_this, arguments);
            }
          };
        };
      })(this));
      return boundMethods;
    };
  }
});

//# sourceMappingURL=../../map/src/BoundMethodCreator.map
