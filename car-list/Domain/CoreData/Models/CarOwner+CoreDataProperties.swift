//
//  CarOwner+CoreDataProperties.swift
//  
//
//  Created by Timur Piriev on 9/16/18.
//
//

import Foundation
import CoreData


extension CarOwner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarOwner> {
        return NSFetchRequest<CarOwner>(entityName: "CarOwner")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var car: Car?

}
