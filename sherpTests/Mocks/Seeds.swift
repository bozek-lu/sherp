//
//  Seeds.swift
//  sherpTests
//
//  Created by Łukasz Bożek on 08/08/2021.
//

import Foundation
@testable import sherp

enum Seeds {
    static func mainPosts() -> [MainViewModels.Post] {
        [
            .init(id: 1, title: "test 1", email: "a@email.com"),
            .init(id: 2, title: "test 2", email: "b@email.com"),
            .init(id: 3, title: "test 3", email: "c@email.com"),
            .init(id: 4, title: "test 4", email: "d@email.com"),
            .init(id: 5, title: "test 5", email: "e@email.com")
        ]
    }
}
