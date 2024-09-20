//
//  WeatherRequest.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import Foundation

struct WeatherRequest {
    
    let lat: Double
    let long: Double
    
    var toJSON: [String: Any] {
        
        return ["lat": lat,
                "lon": long,
                "limit": "100",
                "units": "imperial",
                "appid": API.apiKey]
    }
}
