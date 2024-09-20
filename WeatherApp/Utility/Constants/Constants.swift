//
//  Constants.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import Foundation

struct API {
    static let baseURL = "https://api.openweathermap.org/"
    static let imgBaseURL = "https://openweathermap.org/img/wn/"
    static let apiKey = "d1e6d05f698b598801012a7c692a006c"
}

struct DefaultLocation {
    static let lat = 39.7392
    static let long = 104.9903
}

let AppUserDefaults = UserDefaults.standard
let DispatchQueueMain = DispatchQueue.main

let UD_SELECTED_LOCATION = "selectedLocation"


