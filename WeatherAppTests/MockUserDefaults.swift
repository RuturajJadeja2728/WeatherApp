//
//  MockUserDefaults.swift
//  WeatherAppTests
//
//  Created by User on 9/23/24.
//

import Foundation

class MockUserDefaults: UserDefaults {
    
    var data: Data?

    override func set(_ value: Any?, forKey defaultName: String) {
        data = value as? Data
    }

    override func object(forKey defaultName: String) -> Any? {
        return data
    }
}
