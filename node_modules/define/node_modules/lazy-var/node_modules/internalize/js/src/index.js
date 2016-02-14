module.exports = function(obj, props) {
  var key, value;
  for (key in props) {
    value = props[key];
    Object.defineProperty(obj, key, {
      value: value,
      writable: true,
      configurable: true
    });
  }
  return obj;
};

//# sourceMappingURL=../../map/src/index.map
