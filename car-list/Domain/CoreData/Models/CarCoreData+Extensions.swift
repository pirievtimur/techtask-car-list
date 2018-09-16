extension CarCoreData: Persistable {
    static var entityName: String {
        return "CarCoreData"
    }
    
    static var identifierName: String {
        return "id"
    }
}

extension CarCoreData: DomainConvertibleType {
    var identifier: String {
        return String(id)
    }
    
    func asDomain() -> CarModel {
        return CarModel.init(carCoreData: self)
    }
}
