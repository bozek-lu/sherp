//
//  SherpRequest.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

enum SherpRequest: String {
    /// Request to fetch all posts
    case posts
    
    /// Request to fetch all users
    case users
    
    /// Request to fetch all albums
    case albums
    
    /// Request to fetch all photos
    case photos
}

extension SherpRequest: URLRequestConvertible {
    
    enum Constants {
        static let baseURL = URL(string: "http://jsonplaceholder.typicode.com")!
    }

    func asURLRequest() -> URLRequest {
        let url = Constants.baseURL.appendingPathComponent(self.rawValue)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        return urlRequest
    }
    
}
