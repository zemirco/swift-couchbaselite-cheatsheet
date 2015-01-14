
import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // open db
        var manager = CBLManager.sharedInstance()
        
        var error: NSError?
        var db = manager.databaseNamed("mydb", error: &error)
        if (error != nil) {
            println(error)
        }
        
        // save document
        var properties = [
            "name": "mirco",
            "email": "mirco.zeiss@gmail.com",
            "repo": "swift-couchbaselite-cheatsheet"
        ]
        
        var doc = db.createDocument()
        doc.putProperties(properties, error: &error)
        if (error != nil) {
            println(error)
        }
        
        // Creating and initializing views
        var view = db.viewNamed("name")
        var block: CBLMapBlock = { (doc, emit) in
            emit(doc["name"] as NSString, nil)
        }
        
        view.setMapBlock(block, version: "11")
        
        // Querying views
        var query = db.viewNamed("name").createQuery()
        query.keys = ["mirco"]
        var result = query.run(&error)
        if (error != nil) {
            println(error)
        }
        
        var count = Int(result.count)
        
        for var index = 0; index < count; ++index {
            println(result.rowAtIndex(UInt(index)).document)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
