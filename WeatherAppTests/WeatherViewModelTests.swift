//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by User on 9/19/24.
//

import XCTest
@testable import WeatherApp
import Combine
import CoreLocation

final class WeatherViewModelTests: XCTestCase {
    
    private var weatherViewModel: WeatherViewModel!
    private var mockNetworkManager: MockNetworkManager!
    private var cancellables: Set<AnyCancellable>!
    private var mockUserDefaults: MockUserDefaults!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        weatherViewModel = WeatherViewModel(networkManager: mockNetworkManager)
        cancellables = []
        mockUserDefaults = MockUserDefaults(suiteName: "MockDefaults")
    }
    
    override func tearDown() {
        weatherViewModel = nil
        mockNetworkManager = nil
        cancellables = nil
        mockUserDefaults = nil
        super.tearDown()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testWeatherSuccess() async {
        
        mockNetworkManager.weatherResponse = WeatherData.mockWeatherData()
        
        await weatherViewModel.getWeather(lat: 35.7327, long: 78.8503)
        
        XCTAssertNotNil(weatherViewModel.weatherResponse)
        XCTAssertEqual(weatherViewModel.weatherResponse, mockNetworkManager.weatherResponse)
    }
    
    func testWeatherFailure() async {
        
        mockNetworkManager.isError = true
        
        await weatherViewModel.getWeather(lat: 35.7327, long: 78.8503)
        
        XCTAssertNil(weatherViewModel.weatherResponse)
    }
    
    func testLocationWithSavedLocation() async {
        
        let savedLocation = SearchResponse.mockSearchResponse()
        let encoder = JSONEncoder()
        let savedData = try! encoder.encode(savedLocation)
        AppUserDefaults.set(savedData, forKey: UD_SELECTED_LOCATION)
        
        mockNetworkManager.weatherResponse = WeatherData.mockWeatherData()
        
        await weatherViewModel.getSelectedLocation(currentLocation: nil)
        
        XCTAssertEqual(weatherViewModel.weatherResponse?.coord?.lat, savedLocation.lat)
        XCTAssertEqual(weatherViewModel.weatherResponse?.coord?.lon, savedLocation.lon)
    }
    
    func testLocationWithCurrentLocation() async {
        
        let currentLocation = CLLocationCoordinate2D(latitude: 35.7327, longitude: 78.8503)
        mockNetworkManager.weatherResponse = WeatherData.mockWeatherData()
        
        await weatherViewModel.getSelectedLocation(currentLocation: currentLocation)
        
        
        XCTAssertEqual(weatherViewModel.weatherResponse?.coord?.lat, currentLocation.latitude)
        XCTAssertEqual(weatherViewModel.weatherResponse?.coord?.lon, currentLocation.longitude)
    }
    
    func testGetSelectedLocation_WithNoSavedLocationAndNoCurrentLocation() async {
        
        AppUserDefaults.removeObject(forKey: UD_SELECTED_LOCATION)
        let defaultLatitude = 39.7392
        let defaultLongitude = 104.9903
        mockNetworkManager.weatherResponse = WeatherData.mockWeatherData()
        
        await weatherViewModel.getSelectedLocation(currentLocation: nil)
        
        XCTAssertEqual(DefaultLocation.lat, defaultLatitude)
        XCTAssertEqual(DefaultLocation.long, defaultLongitude)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
