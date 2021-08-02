//
//  Album.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

struct AlbumModel: Decodable {
    let userId: Int
    let id: Int
    let title: String
}
