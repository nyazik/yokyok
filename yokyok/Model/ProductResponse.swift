//
//  ProductResponse.swift
//  yokyok
//
//  Created by Nazik on 13.02.2021.
//

import Foundation

struct ProductResponse: Codable {
    let status: Bool
    let message: String?
    let last_page: Int?
    let data: [ProductDataResponse]
}

struct ProductDataResponse: Codable {
    let id: Int?
    let title: String?
    let photo: String?
    let description: String?
    let categories: String?
    let prices: ProductPriceResponse
    let stock: ProductStockResponse
}

struct ProductPriceResponse: Codable {
    let price: String
    let discount_price: String?
    let is_discount: Int?
}


struct ProductStockResponse: Codable {
    let out_of_stock: Bool?
    let order_limit: Int?
}
