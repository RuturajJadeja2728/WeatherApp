//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import Foundation
import Combine

protocol SearchService {
    func searchCities(text: String) async
}


final class SearchViewModel: ObservableObject, SearchService {
    
    @Published var isLoading: Bool = false
    @Published var searchData : [SearchResponse] = []
    @Published var selectedSearchData : SearchResponse?
    
    private var cancellables = Set<AnyCancellable>()
    private var networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func setSelectedLocation(location : SearchResponse?){
        self.selectedSearchData = location
    }
    
    func getFlagBy(country: String) -> String {
        
        let base : UInt32 = 127397
        var str = ""
        for val in country.unicodeScalars {
            str.unicodeScalars.append(UnicodeScalar(base + val.value)!)
        }
        return String(str)
    }
    
    func searchCities(text: String = "") async {
        
        let request = SearchRequest(keyword: text)
        
        await networkManager.request(endpoint: Endpoint.place, httpMethod: .GET, parameters: request.toJSON,type: [SearchResponse].self).sink { completion in
            switch completion {
            case .failure(let err):
                print("Error: \(err.localizedDescription)")
            case .finished:
                print("Finished")
            }
            
        } receiveValue: { [weak self] data  in
            self?.searchData = data
        }
        .store(in: &cancellables)
        
    }
}
