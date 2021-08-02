//
//  Address+CoreDataProperties.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var city: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var geo: Geo?
    @NSManaged public var user: User?

}

extension Address : Identifiable {

}
