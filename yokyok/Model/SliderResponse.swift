//
//  SliderResponse.swift
//  yokyok
//
//  Created by Nazik on 15.02.2021.
//

import Foundation

struct SliderResponse: Codable {
    let status: Bool
    let message: String?
    let data: [SliderDataResponse]
}

struct SliderDataResponse: Codable {
    let id: Int?
    let image: String?
}
