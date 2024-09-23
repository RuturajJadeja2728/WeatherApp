//
//  MockWeatherData.swift
//  WeatherAppTests
//
//  Created by User on 9/23/24.
//

import Foundation
@testable import WeatherApp

extension WeatherData {
    
    static func mockWeatherData() -> WeatherData {
        
        return WeatherData(
            coord: Coord(lat: 35.7327, lon: 78.8503),
            weather: [
                Weather(id: 802, main: "Clouds", description: "scattered clouds", icon: "03n")
            ],
            base: "stations",
            main: Main(temp: 295.51,
                       feelsLike: 296.15,
                       tempMin: 294.46,
                       tempMax: 296.72,
                       pressure: 1011,
                       humidity: 90
                      ),
            visibility: 10000.0,
            wind: Wind(speed: 1.28,
                       deg: 17,
                       gust: 1.29
                      ),
            snow: Snow(the1H: 0.0),
            clouds: Clouds(all: 48),
            dt: 1726787919,
            sys: Sys(type: 2,
                     id: 2094357,
                     country: "US",
                     sunrise: 1726743686,
                     sunset: 1726787802
                    ),
            timezone: -14400,
            id: 4452808,
            name: "Apex",
            cod: 200
        )
    }
}
