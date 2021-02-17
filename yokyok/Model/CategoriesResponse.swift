//
//  CategoriesResponse.swift
//  yokyok
//
//  Created by Nazik on 13.02.2021.
//

import Foundation

struct CategoriesResponse: Codable {
    let status: Bool
    let message: String?
    let last_page: Int?
    let data: [CategoriesDataResponse?]
}

struct CategoriesDataResponse: Codable {
    let id: Int?
    let title: String?
    let photo: String?
    let count: Int?
    let token: String?
}
