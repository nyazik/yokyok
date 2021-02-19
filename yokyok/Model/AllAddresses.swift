//
//  AllAddresses.swift
//  yokyok
//
//  Created by Nazik on 14.02.2021.
//

import Foundation

struct AllAddressesResponse: Decodable {
    let status: Bool
    let message: String?
    let data: AllAddressesDataResponse?
}

struct AllAddressesDataResponse: Decodable {
    let default_id: Int?
    let addresses: [AllAddressesDetailResponse]?
}

struct AllAddressesDetailResponse: Decodable {
    let id: Int?
    let title: String?
    let address: String?
    let city: Int?
    let city_name: String?
    let county: Int?
    let county_name: String?
}
