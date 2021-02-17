//
//  UpdateUserData.swift
//  yokyok
//
//  Created by Nazik on 14.02.2021.
//

import Foundation


struct UpdateUserData: Codable {
    let status: Bool
    let message: String?
    let data: [UpdateUserResponse?]
}

struct UpdateUserResponse: Codable {
    
}
