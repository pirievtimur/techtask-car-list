import CoreData
import RxSwift

protocol Persistable: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var identifierName: String { get }
}

class FetchRequestBuilder {
    static func request<T: Persistable>(_ type: T.Type) -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: type.entityName)
    }
}
