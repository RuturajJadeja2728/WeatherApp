//
//  SearchResultTableViewCell.swift
//  WeatherApp
//
//  Created by Ruturaj Jadeja on 6/4/23.
//

import UIKit

final class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet private weak var flagLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    func configureData(item: SearchResponse) {
        
        let countryFlag = flag(country: item.country)
        flagLabel.text = countryFlag
        addressLabel.text = item.name + ", " + item.state + ", " + item.country
    }
    
    private func flag(country:String) -> String {
        
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}


