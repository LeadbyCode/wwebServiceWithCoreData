//
//  CacheManager.swift
//  JsonFetchWithCoreData
//
//  Created by Nilesh Vernekar on 07/09/21.
//

import Foundation
import CoreData

class CacheManager: NSObject {
    
    // MARK: - Properties
    
    fileprivate let modelName: String
    fileprivate let entityName: String
    
    
    // MARK: - Initialization
    
    init(modelName: String,entityName: String) {
        self.modelName = modelName
        self.entityName = entityName
    }
    
    // MARK: - Core Data Stack
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var applicationsDocumentDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let persistentStoreURL = applicationsDocumentDirectory.appendingPathComponent(storeName)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: persistentStoreURL,
                                               options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true,NSPersistentStoreFileProtectionKey : FileProtectionType.complete])
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return coordinator
    }()
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.parent = self.saveManagedObjectContext
        
        return managedObjectContext
    }()
    
    private(set) lazy var saveManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    
    @available(iOS 10.0, *)
    fileprivate lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    @available(iOS 10.0, *)
    fileprivate func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: Return Managed Object On BASIS of iOS 10(above) and iOS 10(Below) version
    public func getManagedObject() -> NSManagedObjectContext {
        var context:NSManagedObjectContext
        if #available(iOS 10.0, *) {
            context =  persistentContainer.viewContext
        } else {
            context = managedObjectContext
        }
        
        return context
    }
    
    //MARK: Return Content Object On BASIS of iOS 10(above) and iOS 10(Below) version
    public func saveContextIfChanged() -> Bool {
        var isDataSaved: Bool = false
        let context = getManagedObject()
        if context.hasChanges {
            context.performAndWait() {
                do {
                    try context.save()
                    isDataSaved = true
                } catch {
                    debugPrint("Error saving main managed object context: \(error)")
                }
            }
        }
        return isDataSaved
    }
    
    //MARK:- Retrieve Data
    public func retrieveData<T: NSManagedObject>() -> [T]?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: getManagedObject())
        
        fetchRequest.entity = entityDescription
        
        do{
            let result = try getManagedObject().fetch(fetchRequest) as? [T]
            if ((result?.count)! > 0) {
                return result
            } else {
                return nil
            }
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    //MARK:- Delete Data
    func deleteData(index: Int) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: getManagedObject())
        
        fetchRequest.entity = entityDescription
        do{
            let result = try getManagedObject().fetch(fetchRequest)
            if (result.count > 0) {
                
                getManagedObject().delete(result[index] as! NSManagedObject)
                return true
            } else {
                return false
            }
        } catch {
            return false
            
        }
    }
    
    func deleteObject(managedObject: NSManagedObject) {
        getManagedObject().delete(managedObject)
    }
    
    func clearCache() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: getManagedObject())
        
        fetchRequest.entity = entityDescription
        
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try getManagedObject().execute(DelAllReqVar)
            return true
        }
        catch {
            return false
        }
    }
}
