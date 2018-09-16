//
//  CarCoreData+CoreDataProperties.swift
//  
//
//  Created by Timur Piriev on 9/16/18.
//
//

import Foundation
import CoreData

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

extension CarCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarCoreData> {
        return NSFetchRequest<CarCoreData>(entityName: "CarCoreData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var type: String?
    @NSManaged public var model: String?
    @NSManaged public var color: String?
    @NSManaged public var owners: NSSet?

}

// MARK: Generated accessors for owners
extension CarCoreData {

    @objc(addOwnersObject:)
    @NSManaged public func addToOwners(_ value: CarOwnerCoreData)

    @objc(removeOwnersObject:)
    @NSManaged public func removeFromOwners(_ value: CarOwnerCoreData)

    @objc(addOwners:)
    @NSManaged public func addToOwners(_ values: NSSet)

    @objc(removeOwners:)
    @NSManaged public func removeFromOwners(_ values: NSSet)

}
