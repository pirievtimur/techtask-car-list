import CoreData
import RxSwift

final class Repository<T: Persistable> {
    
    private let executor: ContextExecutorProtocol
    
    init(executor: ContextExecutorProtocol) {
        self.executor = executor
    }
    
    func perform<T>(transaction: @escaping (NSManagedObjectContext) throws -> T) -> Single<T> {
        return executor.execute(transaction: transaction)
    }
    
    func observe(with predicate: NSPredicate? = nil,
                 sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: T.identifierName, ascending: false)])
        -> Observable<[T]> {
            return Observable<[T]>.deferred { [context = executor.context] in
                let request = FetchRequestBuilder.request(T.self)
                request.predicate = predicate
                request.sortDescriptors = sortDescriptors
                return context.rx.observe(fetchRequest: request)
            }
    }
}
