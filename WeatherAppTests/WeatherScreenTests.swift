//
//  WeatherScreenAPIUnitTest.swift
//  WeatherAppTests
//
//  Created by Ruturaj Jadeja on 6/6/23.
//

import XCTest
@testable import WeatherApp

final class WeatherScreenAPIUnitTest: XCTestCase {
    
    func testGetWeatherFromLocationSuceess() {
        
        let networkManager = NetworkManager()
        let weatherRequest = WeatherRequest(lat: 35.7327, long: 78.8503)
        let searchExpectation = self.expectation(description: "GetWeatherFromLocationSuceess")
        networkManager.fetchWeather(param: weatherRequest) { result in
            switch result {
            case .success(let locations):
                XCTAssertNotNil(locations)
                searchExpectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                XCTAssertNil(error.localizedDescription)
                searchExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5)
    }
    
//    func testGetWeatherFromLocationFailuer() {
//
//        let networkManager = NetworkManager()
//        let weatherRequest = WeatherRequest(lat: 0.0, long: 0.0)
//        let searchExpectation = self.expectation(description: "GetWeatherFromLocationSuceess")
//        networkManager.fetchWeather(param: weatherRequest) { result in
//            switch result {
//            case .success(let locations):
//                XCTAssertNil(locations)
//                searchExpectation.fulfill()
//            case .failure(let error):
//                print(error.localizedDescription)
//                XCTAssertNotNil(error.localizedDescription)
//                searchExpectation.fulfill()
//            }
//        }
//        waitForExpectations(timeout: 5)
//    }
}
