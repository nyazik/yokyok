//
//  LoginResponse.swift
//  yokyok
//
//  Created by Nazik on 13.02.2021.
//

import Foundation


struct LoginResponse: Codable {
    let status: Bool
    let message: String
    let data: LoginDataResponse?
}

struct LoginDataResponse: Codable {
    let token: String?
}
