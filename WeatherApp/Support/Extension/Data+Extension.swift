//
//  Data+Extension.swift
//  WeatherApp
//
//  Created by Ruturaj Jadeja on 6/4/23.
//

import Foundation

extension Data {
    
    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self,from:self)
    }
    
    var formattedLength: String {
        
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useAll]
        bcf.countStyle = .file
        return bcf.string(fromByteCount: Int64(self.count))
    }
}
