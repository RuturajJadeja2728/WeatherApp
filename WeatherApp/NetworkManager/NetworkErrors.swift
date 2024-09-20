//
//  NetworkErrors.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import Foundation

enum NetworkErrors: Error {
    case invalidURL
    case invalidResponse
    case unknown
}

extension NetworkErrors {
    
    var errorDescription: String? {
        
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid response."
        case .unknown:
            return "Something went wrong."
        }
    }
}
