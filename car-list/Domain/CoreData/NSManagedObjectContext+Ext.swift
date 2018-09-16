import Foundation
import CoreData

extension NSManagedObjectContext {
    
    enum Errors: Error {
        case noEntity
    }
    
    func create<T: Persistable>() -> T {
        let entity = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as! T
        return entity
    }
    
    func fetch<T: Persistable>(identifier: String) throws -> T? {
        let request = FetchRequestBuilder.request(T.self)
        request.predicate = NSPredicate(format: "\(T.identifierName) == '\(identifier)'")
        let result = try self.fetch(request)
        return result.first
    }
    
    func fetch<T: Persistable>(identifiers: [String]) throws -> [T] {
        let request = FetchRequestBuilder.request(T.self)
        request.predicate = NSPredicate(format: "\(T.identifierName) IN %@", identifiers)
        let result = try self.fetch(request)
        return result
    }
    
    func fetchAll<T: Persistable>() throws -> [T] {
        let request = FetchRequestBuilder.request(T.self)
        let result = try self.fetch(request)
        return result
    }
    
    func fetchOrCreate<T: Persistable>(identifier: String) throws -> T {
        return try fetch(identifier: identifier) ?? self.create()
    }
    
    func fetchFirst<T: Persistable>() throws -> T {
        let request = FetchRequestBuilder.request(T.self)
        request.fetchLimit = 1
        let result = try self.fetch(request)
        guard let first = result.first else {
            throw Errors.noEntity
        }
        return first
    }
}
