//
//  CarOwnerCoreData+CoreDataProperties.swift
//  
//
//  Created by Timur Piriev on 9/16/18.
//
//

import Foundation
import CoreData


extension CarOwnerCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarOwnerCoreData> {
        return NSFetchRequest<CarOwnerCoreData>(entityName: "CarOwnerCoreData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var car: CarCoreData?

}
