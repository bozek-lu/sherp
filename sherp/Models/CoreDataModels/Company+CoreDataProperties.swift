//
//  Company+CoreDataProperties.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var name: String?
    @NSManaged public var bs: String?
    @NSManaged public var catchPhrase: String?
    @NSManaged public var user: User?

}

extension Company : Identifiable {

}
