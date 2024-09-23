//
//  MockNetworkManager.swift
//  WeatherAppTests
//
//  Created by User on 9/19/24.
//

import Foundation
import Combine
@testable import WeatherApp

class MockNetworkManager: NetworkManager {
    
    var weatherResponse: WeatherData?
    var mockSearchResponse: [SearchResponse] = []
    var isError = false
    
    override func request<T: Decodable>(endpoint: Endpoint,
                                          httpMethod: HttpMethods,
                                          parameters: [String: Any],
                                          type: T.Type) async -> Future<T, Error> {
        
        return Future<T, Error> { promise in
            if self.isError {
                promise(.failure(NetworkErrors.invalidResponse))
            } else if let weatherData = self.weatherResponse as? T {
                promise(.success(weatherData))
            } else if  let searchResponse = self.mockSearchResponse as? T {
                promise(.success(searchResponse))
            } else {
                promise(.failure(NetworkErrors.unknown))
            }
        }
    }
}
