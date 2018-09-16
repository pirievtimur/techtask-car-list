extension CarOwnerCoreData: Persistable {
    static var entityName: String {
        return "CarOwnerCoreData"
    }
    
    static var identifierName: String {
        return "id"
    }
}

extension CarOwnerCoreData: DomainConvertibleType {
    var identifier: String {
        return String(id)
    }
    
    func asDomain() -> CarOwner {
        return CarOwner.init(carOwnerCoreData: self)
    }
}
