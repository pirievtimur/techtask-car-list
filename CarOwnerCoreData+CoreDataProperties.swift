//
//  CarOwnerCoreData+CoreDataProperties.swift
//  
//
//  Created by Timur Piriev on 9/16/18.
//
//

import Foundation
import CoreData

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

extension CarOwnerCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarOwnerCoreData> {
        return NSFetchRequest<CarOwnerCoreData>(entityName: "CarOwnerCoreData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var car: CarCoreData?

}
