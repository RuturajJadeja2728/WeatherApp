//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import Foundation

struct WeatherData: Codable {
   
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Double?
    let wind: Wind?
    let snow: Snow?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
    
    var visibilityValue: String {
        let distanceMeters = Measurement(value: visibility ?? 0, unit: UnitLength.meters)
        let miles = distanceMeters.converted(to: UnitLength.miles).value
        return String(format: "Visibility: %.2f mi", miles)
    }
}

struct Clouds: Codable {
    let all: Int?
}

struct Coord: Codable {
    let lon, lat: Double?
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure: Double?
    let humidity: Int?

    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
    
    var pressureValue: Double {
        return ((pressure ?? 0) / 33.864)
    }
    
    var feelsLikeValue: String {
        return "Feels Like \((Int)(floor(feelsLike ?? 0)))°F"
    }
}

struct Snow: Codable {
    let the1H: Double?

    private enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

struct Sys: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
