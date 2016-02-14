node-source-map v0.2.11
===============================

Adapted from [evanw/node-source-map-support](https://github.com/evanw/node-source-map-support).

&nbsp;

additions
---------

##### exports.emptyCache()

When called, the source map cache is cleared exactly like when you set `options.emptyCacheBetweenOperations` to `true` and call `Error.prepareStackTrace()`.

##### frame.orig

When `SourceMap.wrapCallSite()` is called, the returned frame will now have an `orig` property that points to the original frame (the Javascript version).

&nbsp;

install
-------

```sh
npm install aleclarson/node-source-map#0.2.11
```
