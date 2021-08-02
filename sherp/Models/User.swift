//
//  User.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

struct UserModel: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: AddressModel
    let phone: String
    let website: URL
    let company: CompanyModel
}

struct AddressModel: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: GeoModel
}

struct GeoModel: Decodable {
    let lat: Double
    let lng: Double
}

struct CompanyModel: Decodable {
    let name: String
    let catchPhrase: String
    let bs: String
}
