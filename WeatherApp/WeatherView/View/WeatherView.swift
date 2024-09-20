//
//  WeatherView.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var weatherViewModel = WeatherViewModel()
    @ObservedObject var locationManager = LocationManager()
    @State private var selectedSearch: SearchResponse?
    
    var body: some View {
        
        NavigationView {
            
            ZStack(alignment: .top) {
                
                LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    LoadingView(isShowing: weatherViewModel.isLoading) {
                        content
                            .onAppear {
                                Task {
                                    locationManager.callBackUpdatedLocation = { currentLocation in
                                        await weatherViewModel.getSelectedLocation(currentLocation: currentLocation)
                                    }
                                    await weatherViewModel.getSelectedLocation(currentLocation: locationManager.lastLocation)
                                }
                            }
                            .navigationTitle("Weather")
                            .padding()
                    }
                }
            }
        }
    }
    
    var content: some View {
        VStack {
            searchLocationView  // SearchBar
            TemperatureView(weatherResponse: weatherViewModel.weatherResponse)  // Temperature Details
            WeatherDetailView(weatherResponse: weatherViewModel.weatherResponse)    // Weather details
            Spacer()
        }
    }
    
    var searchLocationView: some View {
        HStack {
            NavigationLink(destination: SearchView(callBackSearchResponse: { location in
                self.selectedSearch = location
                weatherViewModel.persistLocation(location)
            })) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .renderingMode(.original)
                        .foregroundColor(.black)
                        .padding(.leading, 15)
                    
                    Text(
                        (weatherViewModel.weatherResponse?.name ?? "") + ", " + (weatherViewModel.weatherResponse?.sys?.country ?? "")
                    )
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(.gray.opacity(0.5))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.gray, lineWidth: 1)
                )
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
