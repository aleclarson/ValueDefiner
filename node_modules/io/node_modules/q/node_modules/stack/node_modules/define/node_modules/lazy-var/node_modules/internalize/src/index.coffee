
module.exports = (obj, props) ->
  for key, value of props
    Object.defineProperty obj, key, { value, writable: yes, configurable: yes }
  obj
