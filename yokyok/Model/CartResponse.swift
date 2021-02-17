//
//  CartResponse.swift
//  yokyok
//
//  Created by Nazik on 16.02.2021.
//

import Foundation

struct CartResponse: Codable {
    let status: Bool
    let message: String?
    let data: CartDataResponse?
}

struct CartDataResponse: Codable {
    let total_basket_price: String?
    let total_products_price: String?
    let courier_price: String?
    let address: AddressResponse
    let products: [CartProductsDetailResponse]?
}

struct AddressResponse: Codable {
    let is_exists: Bool
    let min_price: String?
}


struct CartProductsDetailResponse: Codable {
    let id: Int?
    let title: String?
    let categories: String?
    let count: Int?
    let total: String?

}
