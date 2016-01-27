
import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // open db
        let manager = CBLManager.sharedInstance()
        
        do {
            let db = try manager.databaseNamed("mydb")
            
            // save document
            let properties = [
                "name": "mirco",
                "email": "mirco.zeiss@gmail.com",
                "repo": "swift-couchbaselite-cheatsheet"
            ]
            
            let doc = db.createDocument()
            try doc.putProperties(properties)
            
            // Creating and initializing views
            let view = db.viewNamed("name")
            let block: CBLMapBlock = { (doc, emit) in
                emit(doc["name"] as! String, nil)
            }
            
            view.setMapBlock(block, version: "11")
            
            // Querying views
            let query = db.viewNamed("name").createQuery()
            query.keys = ["mirco"]
            let result = try query.run()
            
            let count = Int(result.count)
            
            for var index = 0; index < count; ++index {
                print(result.rowAtIndex(UInt(index)).document)
            }
            
        } catch {
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
