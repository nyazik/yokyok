//
//  GetHistoricalOrders.swift
//  yokyok
//
//  Created by Nazik on 14.02.2021.
//

import Foundation

struct GetHistoricalOrders: Codable {
    let status: Bool
    let message: String?
    let last_page: Int?
    let data: [GetHistoricalDataResponse?]
}

struct GetHistoricalDataResponse: Codable {
    
}
