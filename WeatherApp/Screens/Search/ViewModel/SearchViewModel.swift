//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Ruturaj Jadeja on 6/4/23.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    
    // MARK: - Private Variables
    
    private let mutableState = BehaviorRelay<State?>(value: nil)
    private let disposeBag: DisposeBag = DisposeBag()
    private var networkManager: Networkable
    private var keyword: String?
    
    init(_ networkManager: Networkable = NetworkManager()) {
        self.networkManager = networkManager
    }
}

// MARK: - API Events

extension SearchViewModel {
    
    private func getSearchData(text: String) {
        
        let parameter = SearchRequest(keyword: text)
        
        networkManager.getSearchData(param: parameter, completion: { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let searchResult):
                self.mutableState.accept(.getSearchData(searchResult))
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

// MARK: - Confirm ViewModel and Implement variable and methods

extension SearchViewModel: ViewModel {
    
    var state: Observable<State> {
        mutableState.filterNil().asObservable()
    }
    
    func onReceiveEvent(_ event: Event) {
        
        switch event {
            
        case .viewDidLoad:
            print("Do the things when view load")
            
        case .onReturnTapped(let text):
            getSearchData(text: text)
        }
    }
}

// MARK: - Configure State and Event as per requirement

extension SearchViewModel {
    
    enum Event: ViewModelEvent {
        
        case viewDidLoad
        case onReturnTapped(String)
    }
    
    enum State: ViewModelState {
        case getSearchData([SearchResponse])
    }
}
