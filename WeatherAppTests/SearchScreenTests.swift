//
//  HomeScreenAPIUnitTest.swift
//  WeatherAppTests
//
//  Created by Ruturaj Jadeja on 6/6/23.
//

import XCTest
@testable import WeatherApp

final class SearchScreenAPIUnitTest: XCTestCase {
    
    func testSearchLocationScreenGetWeatherDataFromLocationSuceess() {
        
        let networkManager = NetworkManager()
        let searchParam = SearchRequest(keyword: "London")
        let searchExpectation = self.expectation(description: "GetWeatherDataFromLocation")
        
        networkManager.getSearchData(param: searchParam) { result in
            switch result {
            case .success(let locations):
                print(locations)
                XCTAssertNotNil(locations)
                XCTAssertEqual(locations[0].name, searchParam.keyword)
                searchExpectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                XCTAssertNotNil(error.localizedDescription)
                searchExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    func testSearchLocationGetWeatherDataFromLocationFailuer(){
        
        let networkManager = NetworkManager()
        let searchParam = SearchRequest(keyword: "")
        let searchExpectation = self.expectation(description: "GetWeatherDataFromLocation")
        
        networkManager.getSearchData(param: searchParam) { result in
            switch result {
            case .success(let locations):
                print(locations)
                XCTAssertNil(locations)
                searchExpectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                XCTAssertNotNil(error.localizedDescription)
                searchExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5)
    }
}




