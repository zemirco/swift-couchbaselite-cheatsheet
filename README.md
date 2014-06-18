
# Swift CouchbaseLite Cheat Sheet

Here is how to use CouchbaseLite in your Swift app.
To get started read the
[docs](http://developer.couchbase.com/mobile/develop/training/build-first-ios-app/create-new-project/index.html).

#### Bridging header

Add all necessary files to your
[bridging header](https://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/buildingcocoaapps/MixandMatch.html).

```
#import "CouchbaseLiteListener.framework/Headers/CBLListener.h"
#import "CouchbaseLite.framework/Headers/CBLAttachment.h"
#import "CouchbaseLite.framework/Headers/CBLAuthenticator.h"
#import "CouchbaseLite.framework/Headers/CBLDatabase.h"
#import "CouchbaseLite.framework/Headers/CBLDatabaseChange.h"
#import "CouchbaseLite.framework/Headers/CBLDocument.h"
#import "CouchbaseLite.framework/Headers/CBLGeometry.h"
#import "CouchbaseLite.framework/Headers/CBLJSON.h"
#import "CouchbaseLite.framework/Headers/CBLManager.h"
#import "CouchbaseLite.framework/Headers/CBLModel.h"
#import "CouchbaseLite.framework/Headers/CBLModelFactory.h"
#import "CouchbaseLite.framework/Headers/CBLQuery.h"
#import "CouchbaseLite.framework/Headers/CBLQuery+FullTextSearch.h"
#import "CouchbaseLite.framework/Headers/CBLQuery+Geo.h"
#import "CouchbaseLite.framework/Headers/CBLReplication.h"
#import "CouchbaseLite.framework/Headers/CBLRevision.h"
#import "CouchbaseLite.framework/Headers/CBLUITableSource.h"
#import "CouchbaseLite.framework/Headers/CBLView.h"
#import "CouchbaseLite.framework/Headers/CouchbaseLite.h"
#import "CouchbaseLite.framework/Headers/MYDynamicObject.h"
```

#### Creating a manager

```swift
var manager = CBLManager.sharedInstance()
```

#### Opening a database

```swift
var error: NSError?
var db = manager.databaseNamed("myDB", error: &error)
if error {
  println(error)
}
```

#### Creating documents

```swift
var properties = [
  "name": "mirco",
  "email": "mirco.zeiss@gmail.com"
  "repo": "swift-couchbaselite-cheatsheet"
]
var doc = db.createDocument()
var error: NSError?
doc.putProperties(properties, error: &error)
if error {
  println(error)
}
```

#### Creating and initializing views

```swift
var view = db.viewNamed("name")
var block: CBLMapBlock = { (doc: NSDictionary!, emit: CBLMapEmitBlock!) in
  emit(doc["name"], nil)
}

view.setMapBlock(block, version: "1")
```

#### Querying views

```swift
var query = db.viewNamed("name").createQuery()
query.keys = ["mirco"]
var error: NSError?
var result = query.run(&error)
if error {
  println(error)
}

for var index = 0; index < result.count; ++index {
  println(result.rowAtIndex(index).value)
}
```

For some reason a `for-in` loop doesn't work.

```js
for row in result {
  println(row.value)
}
```

Xcode starts to freak out and throws errors.

## License

MIT
