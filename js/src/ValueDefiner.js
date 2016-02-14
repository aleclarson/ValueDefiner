var ValueDefiner, Void, assertReturnType, assertType, combine, define, emptyFunction, isType, ref, steal, sync, validateTypes;

require("lotus-require");

ref = require("type-utils"), Void = ref.Void, isType = ref.isType, assertType = ref.assertType, validateTypes = ref.validateTypes, assertReturnType = ref.assertReturnType;

sync = require("io").sync;

emptyFunction = require("emptyFunction");

combine = require("combine");

define = require("define");

steal = require("steal");

module.exports = ValueDefiner = function(config, types) {
  var definers;
  definers = sync.map(types, function(ValueDefinerType) {
    return ValueDefinerType(config);
  });
  return function(instance, args) {
    var definer, i, len;
    for (i = 0, len = definers.length; i < len; i++) {
      definer = definers[i];
      definer(instance, args);
    }
    return instance;
  };
};

ValueDefiner.Type = function(config) {
  var init, key, options, transform;
  validateTypes(config, {
    key: String,
    options: Object,
    init: [Function, Void],
    transform: [Function, Void]
  });
  key = config.key, options = config.options, init = config.init, transform = config.transform;
  if (init == null) {
    init = emptyFunction.thatReturnsArgument;
  }
  if (transform == null) {
    transform = emptyFunction.thatReturnsArgument;
  }
  return function(config) {
    var initValues;
    initValues = init(steal(config, key));
    if (initValues == null) {
      return emptyFunction;
    }
    assertType(initValues, Function);
    return function(instance, args) {
      var values;
      values = initValues.apply(instance, args);
      if (isType(values, Array)) {
        values = combine.apply(null, values);
      }
      assertReturnType(values, Object, {
        key: key
      });
      values = transform(values);
      return define(instance, function() {
        this.options = options;
        return this(values);
      });
    };
  };
};

ValueDefiner.types = [
  ValueDefiner.Type({
    key: "boundMethods",
    init: function(keys) {
      if (!isType(keys, Array)) {
        return;
      }
      return function() {
        var boundMethod, boundMethods, i, key, len, method;
        boundMethods = {};
        for (i = 0, len = keys.length; i < len; i++) {
          key = keys[i];
          method = this[key];
          assertType(method, Function, {
            key: this.constructor.name + "." + key,
            instance: this
          });
          boundMethod = method.bind(this);
          boundMethod.toString = function() {
            return method.toString();
          };
          boundMethods[key] = {
            value: boundMethod,
            enumerable: key[0] !== "_"
          };
        }
        return boundMethods;
      };
    }
  }), ValueDefiner.Type({
    key: "customValues",
    init: function(values) {
      var key, value;
      if (!isType(values, Object)) {
        return;
      }
      for (key in values) {
        value = values[key];
        assertType(value, Object);
        value.enumerable = key[0] !== "_";
      }
      return function() {
        return values;
      };
    }
  }), ValueDefiner.Type({
    key: "initFrozenValues",
    options: {
      frozen: true
    },
    transform: function(values) {
      return sync.map(values, function(value, key) {
        return {
          value: value,
          enumerable: key[0] !== "_"
        };
      });
    }
  }), ValueDefiner.Type({
    key: "initValues",
    options: {
      configurable: false
    },
    transform: function(values) {
      return sync.map(values, function(value, key) {
        return {
          value: value,
          enumerable: key[0] !== "_"
        };
      });
    }
  }), ValueDefiner.Type({
    key: "initReactiveValues",
    options: {
      reactive: true,
      configurable: false
    },
    transform: function(values) {
      return sync.map(values, function(value, key) {
        return {
          value: value,
          enumerable: key[0] !== "_"
        };
      });
    }
  })
];

//# sourceMappingURL=../../map/src/ValueDefiner.map
