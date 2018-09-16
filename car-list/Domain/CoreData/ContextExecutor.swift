import Foundation
import CoreData
import RxSwift

protocol ContextExecutorProtocol {
    var context: NSManagedObjectContext { get }
    func execute<T>(transaction: @escaping (NSManagedObjectContext) throws -> T) -> Single<T>
}

enum ExecutorType {
    case background
    case main
}

final class ContextExecutor: ContextExecutorProtocol {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func execute<T>(transaction: @escaping (NSManagedObjectContext) throws -> T) -> Single<T> {
        return Single.create { [context] single -> Disposable in
            context.perform {
                do {
                    let result = try transaction(context)
                    single(.success(result))
                } catch {
                    single(.error(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
