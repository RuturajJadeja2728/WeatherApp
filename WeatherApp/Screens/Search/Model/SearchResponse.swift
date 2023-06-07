//
//  SearchResponse.swift
//  WeatherApp
//
//  Created by Ruturaj Jadeja on 6/4/23.
//

import Foundation

struct SearchResponse: Codable {
    
    let name: String
    let lat, lon: Double
    let country, state: String
    let localNames: LocalNames?

    enum CodingKeys: String, CodingKey {
        case name, lat, lon, country, state
        case localNames = "local_names"
    }
}

struct LocalNames: Codable {
    let en: String
}
