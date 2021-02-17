//
//  ProductDetailResponse.swift
//  yokyok
//
//  Created by Nazik on 15.02.2021.
//

import Foundation

struct ProductDetailResponse: Codable {
    let status: Bool
    let message: String?
    let last_page: Int?
    let data: ProductDetailDataResponse
}

struct ProductDetailDataResponse: Codable {
    let id: Int?
    let title: String?
    let photo: String?
    let description: String?
    let categories: String?
    let prices: ProductDetailPriceResponse
    let stock: ProductDetailStockResponse
}

struct ProductDetailPriceResponse: Codable {
    let price: String
    let discount_price: String?
    let is_discount: Int?
}


struct ProductDetailStockResponse: Codable {
    let out_of_stock: Bool?
    let order_limit: Int?
}
