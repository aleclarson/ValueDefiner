
# computed-var v1.0.0

```coffee
ComputedVar = require "computed-var"

foo = ComputedVar
  get: -> 1
  set: -> throw Error "umm no"

foo.get() # 1

foo.set 2 # An error is thrown!
```

## install

```sh
npm install aleclarson/computed-var#1.0.0
```
