import Foundation
import CoreData
import RxSwift

protocol ContextSchedulerType: ImmediateSchedulerType {
    init(context: NSManagedObjectContext)
}

final class ContextScheduler: ContextSchedulerType {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        
        let disposable = SingleAssignmentDisposable()
        
        context.performAndWait {
            if disposable.isDisposed {
                return
            }
            disposable.setDisposable(action(state))
        }
        
        return disposable
    }
}
