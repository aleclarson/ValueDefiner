var NamedFunction, ValueCreator, Void, assertType, combine, emptyFunction, isType, ref, setKind, setType, steal, validateTypes;

ref = require("type-utils"), Void = ref.Void, isType = ref.isType, setType = ref.setType, setKind = ref.setKind, assertType = ref.assertType, validateTypes = ref.validateTypes;

NamedFunction = require("named-function");

emptyFunction = require("emptyFunction");

combine = require("combine");

steal = require("steal");

module.exports = ValueCreator = NamedFunction("ValueCreator", function(name, creatorConfig) {
  var factory;
  assertType(name, String);
  validateTypes(creatorConfig, {
    init: [Function, Void],
    transform: [Function, Void]
  });
  if (creatorConfig.init == null) {
    creatorConfig.init = emptyFunction.thatReturnsArgument;
  }
  if (creatorConfig.transform == null) {
    creatorConfig.transform = emptyFunction.thatReturnsArgument;
  }
  factory = NamedFunction(name, function(options) {
    if (options == null) {
      options = {};
    }
    return function(classConfig, key) {
      var createValues, creator;
      assertType(classConfig, Object);
      assertType(key, String);
      createValues = steal(classConfig, key);
      createValues = creatorConfig.init(createValues, options);
      if (createValues == null) {
        return;
      }
      assertType(createValues, Function);
      creator = function(instance, args) {
        var values;
        values = createValues.apply(instance, args);
        assertType(values, [Object, Array]);
        if (isType(values, Array)) {
          values = combine.apply(null, values);
        }
        return creatorConfig.transform(values, options);
      };
      return setType(creator, factory);
    };
  });
  return setKind(factory, ValueCreator);
});

setKind(ValueCreator, Function);

//# sourceMappingURL=../../map/src/ValueCreator.map
