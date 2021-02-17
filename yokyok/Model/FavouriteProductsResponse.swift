//
//  FavouriteProductsResponse.swift
//  yokyok
//
//  Created by Nazik on 15.02.2021.
//

import Foundation

struct FavouriteProductsResponse: Codable {
    let status: Bool
    let message: String?
    let last_page: Int?
    let data: [FavouriteProductsDataResponse]?
}

struct FavouriteProductsDataResponse: Codable {
    let id: Int?
    let title: String?
    let photo: String?
    let description: String?
    let categories: String?
    let prices: FavouriteProductsPriceResponse
    let stock: FavouriteProductsStockResponse
}

struct FavouriteProductsPriceResponse: Codable {
    let price: String
    let discount_price: String?
    let is_discount: Int?
}

struct FavouriteProductsStockResponse: Codable {
    let out_of_stock: Bool?
    let order_limit: Int?
}

