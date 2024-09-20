//
//  TemperatureView.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import SwiftUI
import Kingfisher

struct TemperatureView: View {
    
    var weatherResponse: WeatherData?
    var body: some View {
        
        HStack {
            
            VStack {
                KFImage.url(URL(string: ( "\(API.imgBaseURL)\(weatherResponse?.weather?.first?.icon ?? "01d")@2x.png")))
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .fade(duration: 0.4)
            }
            
            VStack(alignment : .leading) {
                Text(weatherResponse?.weather?.first?.main ?? "")
                Text(weatherResponse?.weather?.first?.description ?? "")
                    .foregroundColor(.black)
            }
        }
//        .padding([.top, 20)
        
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
