//
//  MinPriceResponse.swift
//  yokyok
//
//  Created by Nazik on 19.02.2021.
//

import Foundation

struct MinPriceResponse: Codable {
    let status: Bool
    let message: String?
    let data: MinPriceDataResponse
}

struct MinPriceDataResponse: Codable {
    let min_price: String?
}
