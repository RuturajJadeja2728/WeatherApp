//
//  SearchViewModelTests.swift
//  WeatherAppTests
//
//  Created by User on 9/23/24.
//

import XCTest
@testable import WeatherApp
import Combine

final class SearchViewModelTests: XCTestCase {
    
    private var viewModel: SearchViewModel!
    private var mockNetworkManager: MockNetworkManager!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = SearchViewModel(networkManager: mockNetworkManager)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSetSelectedLocation() {
        
        let searchResponse = SearchResponse.mockSearchResponse()
        viewModel.setSelectedLocation(location: searchResponse)
        XCTAssertEqual(viewModel.selectedSearchData?.name, "Denver")
        XCTAssertEqual(viewModel.selectedSearchData?.country, "US")
    }
    
    func testFlagFunction() {
        let country = "US"
        let flag = viewModel.getFlagBy(country: country)
        XCTAssertEqual(flag, "🇺🇸")
    }
    
    func testSearchCitiesSuccess() async {
        
        let mockResponse = [SearchResponse.mockSearchResponse()]
        mockNetworkManager.mockSearchResponse = mockResponse
        
        await viewModel.searchCities(text: "Denver")
        
        XCTAssertEqual(viewModel.searchData.count, 1)
        XCTAssertEqual(viewModel.searchData[0].name, "Denver")
    }
    
    func testSearchCitiesFailure() async {
        
        mockNetworkManager.isError = true
        await viewModel.searchCities(text: "temp")
        XCTAssertEqual(viewModel.searchData.count, 0)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
