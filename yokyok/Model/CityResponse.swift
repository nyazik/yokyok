//
//  CityResponse.swift
//  yokyok
//
//  Created by Nazik on 15.02.2021.
//

import Foundation

struct CityResponse: Codable {
    let status: Bool
    let message: String?
    let data: [CityDataResponse]?
}

struct CityDataResponse: Codable {
    let id: Int?
    let city: Int?
    let name : String?
}
