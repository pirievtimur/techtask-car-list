import Foundation
import CoreData
import RxSwift
import RxCocoa

protocol CoreDataStackProviderProtocol {
    var privateQueueContext: NSManagedObjectContext { get }
    var mainQueueContext: NSManagedObjectContext { get }
}

final class CoreDataStackProvider: CoreDataStackProviderProtocol {
    
    private(set) lazy var privateQueueContext: NSManagedObjectContext = {
        return createPrivateContext()
    }()
    
    private(set) lazy var mainQueueContext: NSManagedObjectContext = {
        return createMainContext()
    }()
    
    private let persistanceStoreCoordinator: NSPersistentStoreCoordinator
    
    required init(storeName: String, objectModel: NSManagedObjectModel,
                  storeType: String = NSSQLiteStoreType) {
        self.persistanceStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        let storageUrl = applicationDirectoryURL().appendingPathComponent(storeName)
        
        try! self.persistanceStoreCoordinator.addPersistentStore(ofType: storeType,
                                                                 configurationName: nil,
                                                                 at: storageUrl,
                                                                 options: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func createMainContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        context.name = "Main queue context"
        context.persistentStoreCoordinator = persistanceStoreCoordinator
        subscribeForDidSaveNotification(context, selector: #selector(mainContextDidSave(_:)))
        return context
    }
    
    private func createPrivateContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        context.name = "Private queue context"
        context.persistentStoreCoordinator = persistanceStoreCoordinator
        subscribeForDidSaveNotification(context, selector: #selector(privateContextDidSave(_:)))
        return context
    }
    
    private func subscribeForDidSaveNotification(_ context: NSManagedObjectContext, selector: Selector) {
        NotificationCenter.default
            .addObserver(self,
                         selector: selector,
                         name: .NSManagedObjectContextDidSave,
                         object: context)
    }
    
    private func applicationDirectoryURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
}

fileprivate extension CoreDataStackProvider {
    @objc fileprivate func mainContextDidSave(_ notification: Notification) {
        privateQueueContext.perform {
            self.privateQueueContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    @objc fileprivate func privateContextDidSave(_ notification: Notification) {
        mainQueueContext.perform {
            self.mainQueueContext.mergeChanges(fromContextDidSave: notification)
        }
    }
}
