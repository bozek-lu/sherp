//
//  AlbumModel.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

struct AlbumModel: Decodable {
    let userId: Int16
    let id: Int16
    let title: String?
    // Set after the merge with other models
    let photos: [PhotoModel]?
    
    init(from managed: Album) {
        userId = managed.userId
        id = managed.id
        title = managed.title
        if let managedPhotos = managed.photos?.allObjects as? [Photo] {
            photos = managedPhotos.compactMap { PhotoModel(from: $0) }
        } else {
            photos = nil
        }
    }
}
