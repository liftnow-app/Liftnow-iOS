//
//  CoreDataManager.swift
//  LiftNow
//
//  Created by Prithiviraj on 14/06/22.
//

import Foundation
import CoreData

//public class QansModel {
//    var question :String = "";
//    var answer :String = "";
//}

public class CoreDataManager {
    public static let shared = CoreDataManager()
    let identifier: String  = "com.liftnow"       //Your framework bundle ID
    let model: String       = "CoreDataModel"     //Model name
    
    // 4.
    lazy var persistentContainer: NSPersistentContainer = {
        //5
        let messageKitBundle = Bundle(identifier: self.identifier)
        let modelURL = messageKitBundle!.url(forResource: self.model, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
        // 6.
        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                fatalError("❌ Loading of store failed:\(err)")
            }
        }
        
        return container
    }()
    
    public func createRecord(qaList: [QansModel]) {
        let context = persistentContainer.viewContext
        let contact = NSEntityDescription.insertNewObject(forEntityName: "QusAns", into: context) as! QusAns
        contact.date = Date.now
        
        let mRanges = Ranges(ranges: qaList)
        contact.setValue(mRanges, forKeyPath: "range")
        
        do {
            try context.save()
            print("✅ Data saved in DB succesfuly")
        } catch let error {
            print("❌ Failed to create Person: \(error.localizedDescription)")
        }
    }
    public func fetchRecord()->[QusAns] {
        var qaList = [QusAns]()
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<QusAns>(entityName: "QusAns")
        do {
            let persons = try context.fetch(fetchRequest)
            qaList = persons
            //            for (index,person) in persons.enumerated() {
            //                print(index)
            //                print(person.date ?? Date.now)
            //                let range = person.range
            //                let ranges = range?.ranges
            //                print(ranges ?? [])
            //            }
        } catch let fetchErr {
            print("❌ Failed to fetch QusAns:",fetchErr)
        }
        return qaList
    }
}
