//
//  TemperatureView.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import SwiftUI

struct TemperatureView: View {
    
    var weatherResponse: WeatherData?
    var body: some View {
        
        HStack {
            
            VStack {
                AsyncImage(url: URL(string: "\(API.imgBaseURL)\(weatherResponse?.weather?.first?.icon ?? "01d")@2x.png")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 60, height: 60)
            }
            
            VStack(alignment : .leading) {
                Text(weatherResponse?.weather?.first?.main ?? "")
                Text(weatherResponse?.weather?.first?.description ?? "")
                    .foregroundColor(.black)
            }
        }
        
        Text("\((Int)(floor(weatherResponse?.main?.temp ?? 0)))°F")
            .font(.system(size: 50) .bold())
            .foregroundColor(.white)
        
        Text(weatherResponse?.main?.feelsLikeValue ?? "0")
            .foregroundColor(.white)
    }
}

struct TemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureView()
    }
}
