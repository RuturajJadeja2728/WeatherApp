//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import Foundation
import Combine
import CoreLocation

protocol WeatherService {
    func getWeather(lat: Double, long: Double) async
}


final class WeatherViewModel: ObservableObject, WeatherService {
    
    @Published var weatherResponse: WeatherData?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func getWeather(lat: Double, long: Double) async {
        
        DispatchQueueMain.async {
            self.isLoading = true
        }
        
        let request = WeatherRequest(lat: lat, long: long)
        
        await NetworkManager.shared.request(endpoint: .getWeather,
                                                    httpMethod: .GET,
                                                    parameters: request.toJSON,
                                                    type: WeatherData.self)
        .sink { completion in
            self.isLoading = false
            switch completion {
            case .failure(let err):
                print("Error: \(err.localizedDescription)")
            case .finished:
                print("Finished")
            }
        } receiveValue: { [weak self] data  in
            self?.isLoading = false
            self?.weatherResponse = data
        }
        .store(in: &cancellables)
    }
    
    func persistLocation(_ location: SearchResponse) {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(location) {
            AppUserDefaults.set(encoded, forKey: UD_SELECTED_LOCATION)
        }
    }
    
    func getSelectedLocation(currentLocation: CLLocationCoordinate2D?) async {
    
        // Retrive last selected location weather data
        if let savedLocation = AppUserDefaults.object(forKey: UD_SELECTED_LOCATION) as? Data {
            let decoder = JSONDecoder()
            if let selectedLocation = try? decoder.decode(SearchResponse.self, from: savedLocation) {
                await getWeather(lat: selectedLocation.lat, long: selectedLocation.lon)
            }
        } else {    // Retrive default location weather data
            
            if let currentLocation = currentLocation {
                await getWeather(lat: currentLocation.latitude, long: currentLocation.longitude)
            } else {
                await getWeather(lat: DefaultLocation.lat, long: DefaultLocation.long)
            }
        }
    }
}
