import Foundation
import RxSwift
import RxCocoa
import CoreData
@testable import car_list

final class ImmediateContextExecutor: ContextExecutorProtocol {
    
    let context : NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func execute<T>(transaction: @escaping (NSManagedObjectContext) throws -> T) -> Single<T> {
        return Single.create { single -> Disposable in
            self.context.performAndWait {
                do {
                    let result = try transaction(self.context)
                    single(.success(result))
                } catch {
                    single(.error(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
