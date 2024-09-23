//
//  MockSearchData.swift
//  WeatherAppTests
//
//  Created by User on 9/23/24.
//

import Foundation
@testable import WeatherApp

extension SearchResponse {
    
    static func mockSearchResponse() -> SearchResponse {
        
        return SearchResponse(
            id: UUID().uuidString,
            name: "Denver",
            lat: 35.7327,
            lon: 78.8503,
            country: "US",
            state: "Colorado",
            localNames: LocalNames(
                id: UUID().uuidString,
                en: "US"
            )
        )
    }
}
