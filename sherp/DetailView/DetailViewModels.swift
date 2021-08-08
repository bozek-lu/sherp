//
//  DetailViewModels.swift
//  sherp
//
//  Created by Łukasz Bożek on 08/08/2021.
//

import UIKit

typealias DataSource = UICollectionViewDiffableDataSource<Section<Header, [PhotoElement]>, PhotoElement>

struct Section<U: Hashable, T: Hashable>: Hashable {
    var headerItem: U
    let items: T
}

struct Header: Hashable {
    let title: String
    let body: String?
    let isDetails: Bool
    var isExpanded: Bool
}

struct PhotoElement: Hashable {
    let thumbnailURL: URL?
    let fullURL: URL?
}
