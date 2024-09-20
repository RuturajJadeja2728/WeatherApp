//
//  SearchView.swift
//  WeatherApp
//
//  Created by User on 9/18/24.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchText: String = ""
    @Environment(\.dismiss) var dismiss
    @ObservedObject var searchViewModel = SearchViewModel()
    var callBackSearchResponse : (_ selectedSearchData : SearchResponse) -> ()
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .renderingMode(.original)
                    .foregroundColor(.black)
                    .padding(.leading,20)
                TextField("Search here", text: $searchText)
                    .onSubmit {
                        Task {
                            searchViewModel.searchData = []
                            await searchViewModel.searchCities(text: searchText)
                        }
                    }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: 44
            )
            .background(.gray.opacity(0.4))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.gray, lineWidth: 1))
            .padding()
            
            
            
            if (searchViewModel.isLoading){
                Spacer()
                ProgressView()
            } else {
                if searchViewModel.searchData.count > 0 {
                    List(searchViewModel.searchData, id: \.id) { place in
                        
                        HStack{
                            Text(searchViewModel.getFlagBy(country: place.country))
                            Text(place.name + ", " + place.state + ", " + place.country)
                            
                        }
                        .onTapGesture {
                            callBackSearchResponse(place)
                            dismiss()
                        }
                    }
                } else {
                    Spacer()
                    Text("No Results Found")
                }
                
            }
            Spacer()
            
        }
        .navigationTitle("Search")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView { selectedSearchData in
            
        }
    }
}
