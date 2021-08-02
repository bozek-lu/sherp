//
//  Geo+CoreDataProperties.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//
//

import Foundation
import CoreData


extension Geo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Geo> {
        return NSFetchRequest<Geo>(entityName: "Geo")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lan: Double
    @NSManaged public var address: Address?

}

extension Geo : Identifiable {

}
