//
//  PreviousOrderDetailResponse.swift
//  yokyok
//
//  Created by Nazik on 19.02.2021.
//

import Foundation

struct PreviousOrderDetailResponse: Codable {
    let status: Bool
    let message: String?
    let data: [PreviousOrderDataResponse]?
}

struct PreviousOrderDataResponse: Codable {
    let price: String?
    let count: Int?
    let original: OriginalDataResponse
}

struct OriginalDataResponse: Codable {
    let id: Int?
    let title: String?
    let description: String?
    let photo: String?
    let categories: String?
    let prices: PricesResponse?
    let stock: StockResponse?
}

struct PricesResponse: Codable {
    let price: String?
    let discount_price: String?
    let is_discount: Int?
}

struct StockResponse: Codable {
    let out_of_stock: Bool?
    let order_limit: Int?
}
