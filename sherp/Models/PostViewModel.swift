//
//  PostViewModel.swift
//  sherp
//
//  Created by Łukasz Bożek on 06/08/2021.
//

import Foundation

protocol PostElement { }

enum PostViewModel {
    struct Simple {
        let id: Int16
        let title: String
        let email: String
    }
    
    struct Details: PostElement {
        let title: String
        let body: String
    }
    
    struct Album: PostElement {
        let name: String
    }
}
