//
//  SearchRequest.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import Foundation

struct SearchRequest {
    
    let keyword: String
    
    var toJSON: [String: Any] {
        
        return ["q": keyword,
                "limit": "100",
                "appid": API.apiKey]
    }
}
