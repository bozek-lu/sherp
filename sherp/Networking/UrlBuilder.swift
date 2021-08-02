//
//  UrlBuilder.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

protocol UrlBuilderProtocol {
    func build() -> URL?
}

enum UrlBuilder: String {
    case posts
    case users
    case albums
    case photos
}

extension UrlBuilder: UrlBuilderProtocol {

    enum Constants {
        static let baseURL = URL(string: "http://jsonplaceholder.typicode.com")!
    }

    func build() -> URL? {
        return Constants.baseURL.appendingPathComponent(self.rawValue)
    }
}
