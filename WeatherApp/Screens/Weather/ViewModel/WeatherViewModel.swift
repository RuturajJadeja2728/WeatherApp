//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Ruturaj Jadeja on 6/5/23.
//

import Foundation
import RxSwift
import RxRelay

final class WeatherViewModel {
    
    // MARK: - Private Variables
    
    private let mutableState = BehaviorRelay<State?>(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()
    private var networkManager: Networkable
    
    init(_ networkManager: Networkable = NetworkManager()) {
        self.networkManager = networkManager
    }
}

// MARK: - API Events

extension WeatherViewModel {
    
    private func getWeatherData(lat: Double, long: Double) {
        
        mutableState.accept(.showLoading(true))
        
        let parameter = WeatherRequest(lat: lat, long: long)
        
        networkManager.fetchWeather(param: parameter, completion: { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let weather):
                self.mutableState.accept(.showLoading(false))
                self.mutableState.accept(.showWeatherData(weather))
            case .failure(let error):
                self.mutableState.accept(.showLoading(false))
                print(error.localizedDescription)
            }
        })
    }
}


// MARK: - Confirm ViewModel and Implement variable and methods

extension WeatherViewModel: ViewModel {
    
    var state: Observable<State> {
        mutableState.filterNil().asObservable()
    }
    
    func onReceiveEvent(_ event: Event) {
        
        switch event {
            
        case .viewDidLoad:
            print("Do the things when view load")
            
        case .onSearchItem(let lat, let long):
            getWeatherData(lat: lat, long: long)
        }
    }
}

// MARK: - Configure State and Event as per requirement

extension WeatherViewModel {
    
    enum Event: ViewModelEvent {
        case viewDidLoad
        case onSearchItem(Double, Double)
    }
    
    enum State: ViewModelState {
        case showLoading(Bool)
        case showWeatherData(WeatherData)
    }
}
