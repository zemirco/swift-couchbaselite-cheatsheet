
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
var db = manager.databaseNamed("mydb", error: &error)
if error {
  println(error)
}
```

#### Creating documents

```swift
var properties = [
  "name": "mirco",
  "email": "mirco.zeiss@gmail.com",
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

```swift
for row in result {
  println(row.value)
}
```

Xcode starts to freak out and throws errors.

#### Query by timestamp

Add document with timestamp.

```swift
var timestamp = NSDate().timeIntervalSince1970 * 1000 as Double

var person: Dictionary<String, String> = [
    "timestamp": timestamp,
    "type": "person",
    "name": "mirco"
]
```

Now query the view and get all persons in the order they were added to db.

```swift
var db = getDatabase("people")
var view = db.viewNamed("persons")
var map: CBLMapBlock = { (doc: NSDictionary!, emit: CBLMapEmitBlock!) in
    if doc["type"] {
        if doc["type"] as NSString == "person" {
            emit(doc["timestamp"] as Double, doc)
        }
    }
}
view.setMapBlock(map, version: "1")

// get all moves between date in the future
// 2999-12-31 = 32503593600000
// and date in the past
// 2013-01-01 = 1356998400000

var query = db.viewNamed("persons").createQuery()
query.startKey = 1356998400000 as Double
query.endKey = 32503593600000 as Double
var error: NSError?
var data = query.run(&error)
if error {
    println(error)
}
```

#### Updating a document

```swift
var db = getDatabase("people")
var personDocument = db.documentWithID(personId)

var error: NSError?
personDocument.update({ (newRev: CBLUnsavedRevision!) in
    newRev["name"] = "john"
    return true
}, error: &error)

if error {
    println(error)
}
```

## License

MIT
