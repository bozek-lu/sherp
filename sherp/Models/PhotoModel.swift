//
//  PhotoModel.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

struct PhotoModel: Decodable {
    let albumId: Int16
    let id: Int16
    let title: String?
    let url: URL?
    let thumbnailUrl: URL?
    
    init(from managed: Photo) {
        albumId = managed.albumId
        id = managed.id
        title = managed.title
        url = managed.url
        thumbnailUrl = managed.thumbnailUrl
    }
}
