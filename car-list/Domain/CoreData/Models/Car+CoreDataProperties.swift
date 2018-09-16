//
//  Car+CoreDataProperties.swift
//  
//
//  Created by Timur Piriev on 9/16/18.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var id: String?
    @NSManaged public var type: String?
    @NSManaged public var model: String?
    @NSManaged public var color: String?
    @NSManaged public var owners: NSSet?

}

// MARK: Generated accessors for owners
extension Car {

    @objc(addOwnersObject:)
    @NSManaged public func addToOwners(_ value: CarOwner)

    @objc(removeOwnersObject:)
    @NSManaged public func removeFromOwners(_ value: CarOwner)

    @objc(addOwners:)
    @NSManaged public func addToOwners(_ values: NSSet)

    @objc(removeOwners:)
    @NSManaged public func removeFromOwners(_ values: NSSet)

}
