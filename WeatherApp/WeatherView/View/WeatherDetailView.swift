//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import SwiftUI

struct WeatherDetailView: View {
    
    var weatherResponse: WeatherData?
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading) {
                
                Color.gray.opacity(0.4)
                
                Text("Wind: \(weatherResponse?.wind?.speed ?? 0) mph")
                Divider()
                
                Text(String(format: "Pressure: %.2f inHg", weatherResponse?.main?.pressureValue ?? 0))
                Divider()
                
                Text("Humidity: \(weatherResponse?.main?.humidity ?? 0)%")
                Divider()
                
                
                let distanceMeters = Measurement(value: weatherResponse?.visibility ?? 0, unit: UnitLength.meters)
                let miles = distanceMeters.converted(to: UnitLength.miles).value
                Text(String(format: "Visibility: %.2f mi", miles))
                Divider()
            }
            .font(.system(size: 17))
            .padding()
        }
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView()
    }
}
