//
//  CarCoreData+CoreDataProperties.swift
//  
//
//  Created by Timur Piriev on 9/16/18.
//
//

import Foundation
import CoreData


extension CarCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarCoreData> {
        return NSFetchRequest<CarCoreData>(entityName: "CarCoreData")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: Int64
    @NSManaged public var model: String?
    @NSManaged public var type: String?
    @NSManaged public var owner: NSSet?

}

// MARK: Generated accessors for owner
extension CarCoreData {

    @objc(addOwnerObject:)
    @NSManaged public func addToOwner(_ value: CarOwnerCoreData)

    @objc(removeOwnerObject:)
    @NSManaged public func removeFromOwner(_ value: CarOwnerCoreData)

    @objc(addOwner:)
    @NSManaged public func addToOwner(_ values: NSSet)

    @objc(removeOwner:)
    @NSManaged public func removeFromOwner(_ values: NSSet)

}
