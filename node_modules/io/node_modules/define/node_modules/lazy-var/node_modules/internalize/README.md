
# internalize v1.0.0

```coffee
internalize = require "internalize"

foo = {}

internalize foo,
  _bar: 1

foo      # {}
foo._bar # 1
```

## install

```sh
npm install aleclarson/internalize#1.0.0
```
