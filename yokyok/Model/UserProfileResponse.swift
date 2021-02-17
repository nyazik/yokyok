//
//  UserProfileResponse.swift
//  yokyok
//
//  Created by Nazik on 15.02.2021.
//

import Foundation

struct UserProfileResponse: Codable {
    let status: Bool
    let message: String?
    let data: UserProfileDataResponse?
}

struct UserProfileDataResponse: Codable {
    let id: Int?
    let email: String?
    let name : String?
    let phone: String?
    let photo: String?
}
