//
//  SearchRequest.swift
//  WeatherApp
//
//  Created by Ruturaj Jadeja on 6/4/23.
//

import Foundation

struct SearchRequest {
    
    let keyword: String
    
    var toJSON: [String: Any] {
        
        return ["q": keyword,
                "limit": 100,
                "appid": OpenWeatherApiKey]
    }
}
