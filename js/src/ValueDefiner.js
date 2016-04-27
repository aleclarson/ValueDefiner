var NamedFunction, ValueCreator, ValueDefiner, Void, assertType, combine, define, emptyFunction, guard, isDev, ref, setKind, setType, sync, throwFailure, validateTypes;

ref = require("type-utils"), Void = ref.Void, setType = ref.setType, setKind = ref.setKind, assertType = ref.assertType, validateTypes = ref.validateTypes;

throwFailure = require("failure").throwFailure;

NamedFunction = require("NamedFunction");

emptyFunction = require("emptyFunction");

combine = require("combine");

define = require("define");

isDev = require("isDev");

guard = require("guard");

sync = require("sync");

ValueCreator = require("./ValueCreator");

module.exports = ValueDefiner = NamedFunction("ValueDefiner", function(classConfig, options) {
  var definer, valueCreators;
  assertType(classConfig, Object);
  validateTypes(options, {
    valueCreatorTypes: Object,
    defineValues: [Function, Void],
    didDefineValues: [Function, Void]
  });
  valueCreators = {};
  sync.each(options.valueCreatorTypes, function(ValueCreator, key) {
    var valueCreator;
    valueCreator = ValueCreator(classConfig, key);
    if (valueCreator) {
      return valueCreators[key] = valueCreator;
    }
  });
  if (options.defineValues == null) {
    options.defineValues = function(valueConfigs) {
      return define(this, valueConfigs);
    };
  }
  definer = function(instance, args) {
    var definedValues, ref1;
    if (options.didDefineValues) {
      definedValues = {};
    }
    sync.each(valueCreators, function(createValues, key) {
      return guard(function() {
        var valueConfigs;
        valueConfigs = createValues(instance, args);
        if (!valueConfigs) {
          return;
        }
        assertType(valueConfigs, Object);
        if (options.didDefineValues) {
          sync.each(valueConfigs, function(config, key) {
            return definedValues[key] = combine({}, config);
          });
        }
        return options.defineValues.call(instance, valueConfigs, key, options.valueCreatorTypes[key]);
      }).fail(function(error) {
        return throwFailure(error, {
          key: key
        });
      });
    });
    if ((ref1 = options.didDefineValues) != null) {
      ref1.call(instance, definedValues);
    }
    return instance;
  };
  return setType(definer, ValueDefiner);
});

setKind(ValueDefiner, Function);

//# sourceMappingURL=../../map/src/ValueDefiner.map
