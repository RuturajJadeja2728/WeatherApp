//
//  UIImageView.swift
//  WeatherApp
//
//  Created by Ruturaj Jadeja on 6/6/23.
//

import UIKit

extension UIImageView {
    
    func loadImage(url: URL) {
        
        DispatchQueue.global().async { [weak self] in
            
            if let data = try? Data(contentsOf: url) {
                
                if let image = UIImage(data: data) {
                    
                    DispatchQueueMain.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
