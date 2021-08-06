//
//  Post+CoreDataProperties.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var userId: Int16
    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var user: User?

}

extension Post : Identifiable {

}
