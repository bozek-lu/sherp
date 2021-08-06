//
//  Photo+CoreDataProperties.swift
//  sherp
//
//  Created by Łukasz Bożek on 07/08/2021.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var albumId: Int16
    @NSManaged public var id: Int16
    @NSManaged public var thumbnailUrl: URL?
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var album: Album?

}

extension Photo : Identifiable {

}
