import CoreData
@testable import car_list

extension NSManagedObjectContext {
    class func inMemoryTestContext(_ bundle: Bundle = .main) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let managedObjectModel = NSManagedObjectModel(with: "car_list", bundle: bundle)!
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let storageUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        
        try! storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: storageUrl, options: nil)
        
        context.persistentStoreCoordinator = storeCoordinator
        context.name = "car_list unit tests context"
        return context
    }
}
