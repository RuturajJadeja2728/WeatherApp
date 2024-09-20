//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by User on 9/19/24.
//

import XCTest
@testable import WeatherApp
import Combine

final class WeatherViewModelTests: XCTestCase {
    
    private var weatherViewModel: WeatherViewModel!
    private var mockNetworkManager: MockNetworkManager!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        weatherViewModel = WeatherViewModel()
        mockNetworkManager = MockNetworkManager()
        cancellables = []
    }
    
    override func tearDown() {
        weatherViewModel = nil
        mockNetworkManager = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testWeatherSuccess() async {
        
        mockNetworkManager.weatherResponse = Future { promise in
            promise(.success(
                WeatherData(
                    coord: Coord(lon: -78.8503, lat: 35.7327),
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
            ))}.eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "Weather loaded using Combine Future")
        
        mockNetworkManager.weatherResponse?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(_):
                    print("error")
                }
            }, receiveValue: { weather in
                XCTAssertEqual(weather.name, "Apex")
                expectation.fulfill()
            })
            .store(in: &cancellables)
//
        NetworkManager.shared = mockNetworkManager
        
        await weatherViewModel.getWeather(lat: -78.8503, long: 35.7327)
        
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    func testWeatherFailure() async {
        
        mockNetworkManager.weatherResponse = Future { promise in
            promise(.failure(URLError(.badServerResponse)))
        }.eraseToAnyPublisher()
        
        NetworkManager.shared = mockNetworkManager
        
        let expectation = XCTestExpectation(description: "Weather fetch failed")
        
        mockNetworkManager.weatherResponse?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(_):
                    print("error")
                    expectation.fulfill()
                }
            }, receiveValue: { weather in
                XCTAssertEqual(weather.name, "Apex")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        await weatherViewModel.getWeather(lat: -78.8503, long: 35.7327)
        
        await fulfillment(of: [expectation], timeout: 3)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
