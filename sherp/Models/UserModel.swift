//
//  UserModel.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

struct UserModel: Decodable {
    let id: Int16
    let name: String?
    let username: String?
    let email: String?
    
    init(from managed: User) {
        id = managed.id
        name = managed.name
        username = managed.username
        email = managed.email
    }
}
