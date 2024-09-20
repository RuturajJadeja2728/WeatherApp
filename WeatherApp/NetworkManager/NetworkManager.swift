//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import Foundation
import Combine

enum Endpoint: String {
    case getWeather = "data/2.5/weather"
    case place = "geo/1.0/direct"
}

enum HttpMethods: String {
    case GET
    case POST
}

class NetworkManager {
    
    static var shared = NetworkManager()
    
    private var cancellables = Set<AnyCancellable>()
    private var session = URLSession.shared
    
    func configureSession(_ session: URLSession) {
        self.session = session
    }
    
    func request<T: Decodable>(endpoint: Endpoint,
                                       httpMethod: HttpMethods,
                                       parameters: [String: Any],
                                       type: T.Type) async -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self, let url = URL(string: API.baseURL.appending(endpoint.rawValue)) else {
                return promise(.failure(NetworkErrors.invalidURL))
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            
            if httpMethod == .GET {
                let queryItems = parameters.map { key, value in
                    URLQueryItem(name: key, value: "\(value)")
                }
                if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    urlComponents.queryItems = queryItems
                    request.url = urlComponents.url
                }
            }
            
            session.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkErrors.invalidResponse
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkErrors:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkErrors.unknown))
                        }
                    }
                }, receiveValue: { value in
                    promise(.success(value))
                })
                .store(in: &cancellables)
        }
    }
}
