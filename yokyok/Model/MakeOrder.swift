//
//  MakeOrder.swift
//  yokyok
//
//  Created by Nazik on 19.02.2021.
//

import Foundation

struct MakeOrder: Codable {
    let status: Bool
    let message: String?
    let last_page: Int?
    let data: [MakeOrderDataResponse?]
}

struct MakeOrderDataResponse: Codable {
    let id: Int?
    let address_title: String?
    let address: String?
    let total_price: String?
    let created_at: String
}
