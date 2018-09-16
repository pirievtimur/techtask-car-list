import CoreData
import RxSwift

extension Reactive where Base: NSManagedObjectContext {
    
    func observe<Entity>(fetchRequest: NSFetchRequest<Entity>,
                         sectionNameKeyPath: String? = nil,
                         cacheName: String? = nil) -> Observable<[Entity]> {
        return Observable.create { observer in
            
            let observerAdapter = FetchedResultsControllerEntityObserver(observer: observer,
                                                                         fetchRequest: fetchRequest,
                                                                         managedObjectContext: self.base,
                                                                         sectionNameKeyPath: sectionNameKeyPath,
                                                                         cacheName: cacheName)
            
            return Disposables.create {
                observerAdapter.dispose()
            }
        }
    }
    
    func entities<Entity>(fetchRequest: NSFetchRequest<Entity>,
                          sectionNameKeyPath: String? = nil,
                          cacheName: String? = nil) -> Single<[Entity]> {
        return .create { single in
            do {
                let result = try self.base.fetch(fetchRequest)
                single(.success(result))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func save() -> Completable {
        return .create { completable in
            do {
                try self.base.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func delete<Entity: NSManagedObject>(entity: Entity) -> Completable {
        return .create { completable in
            self.base.delete(entity)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func delete<Model: CoreDataRepresentable>(entities: [Model]) -> Completable {
        typealias Entity = Model.CoreDataType
        return .deferred {
            let request = NSFetchRequest<Entity>(entityName: Entity.entityName)
            let identifiers = entities.map { $0.identifier }
            request.predicate = NSPredicate(format: "\(Entity.identifierName) IN %@", identifiers)
            
            return self.entities(fetchRequest: request)
                .do(onSuccess: { $0.forEach(self.base.delete) })
                .asCompletable()
        }
    }
    
    func first<Entity: Persistable>(ofType: Entity.Type = Entity.self,
                                    with predicate: NSPredicate?) -> Single<Entity?> {
        return .create { single in
            let entityName = Entity.entityName
            let request = NSFetchRequest<Entity>(entityName: entityName)
            request.predicate = predicate
            do {
                let result = try self.base.fetch(request).first
                single(.success(result))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
