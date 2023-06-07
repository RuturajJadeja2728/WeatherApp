//
//  ExtensionTableViewCell.swift
//  WeatherApp
//
//  Created by Ruturaj Jadeja on 6/4/23.
//

import UIKit

extension UITableViewCell {
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
