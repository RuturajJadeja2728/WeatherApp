//
//  WeatherModelTests.swift
//  WeatherAppTests
//
//  Created by User on 9/19/24.
//

import XCTest
import Foundation
@testable import WeatherApp

final class WeatherModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWeatherModelDecoding() {
        
        let sampleJSON = """
        {
          "coord": {
            "lon": -78.8503,
            "lat": 35.7327
          },
          "weather": [
            {
              "id": 803,
              "main": "Clouds",
              "description": "broken clouds",
              "icon": "04d"
            }
          ],
          "base": "stations",
          "main": {
            "temp": 295.77,
            "feels_like": 296.44,
            "temp_min": 294.58,
            "temp_max": 297.47,
            "pressure": 1014,
            "humidity": 90,
            "sea_level": 1014,
            "grnd_level": 1001
          },
          "visibility": 10000,
          "wind": {
            "speed": 4.63,
            "deg": 30
          },
          "clouds": {
            "all": 75
          },
          "dt": 1726763076,
          "sys": {
            "type": 2,
            "id": 2094357,
            "country": "US",
            "sunrise": 1726743686,
            "sunset": 1726787802
          },
          "timezone": -14400,
          "id": 4452808,
          "name": "Apex",
          "cod": 200
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let weather = try decoder.decode(WeatherData.self, from: sampleJSON)
            
            // Then
            XCTAssertEqual(weather.name, "Apex")
            XCTAssertEqual(weather.main?.temp, 295.77)
            XCTAssertEqual(weather.weather?.first?.description, "broken clouds")
            XCTAssertEqual(weather.weather?.first?.icon, "04d")
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }
    
    func testWeatherModelDecodingError() {
            
            let invalidJSON = """
            {
                "cod":"404",
                "message":"city not found"
            }
            """.data(using: .utf8)!
        
            let decoder = JSONDecoder()
            
            do {
                _ = try decoder.decode(WeatherData.self, from: invalidJSON)
                XCTFail("Decoding should have failed with missing keys")
            } catch {
                // Then
                XCTAssertTrue(true, "Expected failure, got error: \(error)")
            }
        }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
