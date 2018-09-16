import CoreData
import RxSwift

protocol DomainConvertibleType {
    associatedtype DomainType: CoreDataRepresentable
    typealias Identifier = DomainType.Identifier
    
    var identifier: Identifier { get }
    
    func asDomain() -> DomainType
}

protocol CoreDataRepresentable {
    associatedtype CoreDataType: NSManagedObject, Persistable, DomainConvertibleType
    associatedtype Identifier: Hashable
    
    var identifier: Identifier { get }
}
