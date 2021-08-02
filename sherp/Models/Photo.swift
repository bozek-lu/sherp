//
//  Photo.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

struct PhotoModel: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
}
