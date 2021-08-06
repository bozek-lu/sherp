//
//  PostModel.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

enum PostError: Error {
    case fetchingFail
    case dbFail
}

struct PostModel: Decodable {
    let userId: Int16
    let id: Int16
    let title: String?
    let body: String?
    // Set after the merge with other models
    var user: UserModel?
    
    init(from managed: Post) {
        userId = managed.userId
        id = managed.id
        title = managed.title
        body = managed.body
        if let managedUser = managed.user {
            user = UserModel(from: managedUser)
        } else {
            user = nil
        }
    }
}
