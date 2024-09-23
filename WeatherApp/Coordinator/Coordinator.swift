//
//  Coordinator.swift
//  WeatherApp
//
//  Created by User on 9/22/24.
//

import Foundation
import SwiftUI

enum AppPages {
    case weather
}

enum Sheet: String, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case search
}

class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    
    var dismissSheetCallback: ((Any?) -> Void)?
    
    func push(page: AppPages) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func presentSheet<T>(_ sheet: Sheet, onDismiss: @escaping (T?) -> Void) {
        self.sheet = sheet
        self.dismissSheetCallback = { value in
            onDismiss(value as? T)
        }
    }
    
    func dismissSheet<T>(_ result: T? = nil) {
        self.sheet = nil
        dismissSheetCallback?(result)
    }
    
    @ViewBuilder
    func build(page: AppPages) -> some View {
        switch page {
        case .weather:
            WeatherView()
        }
    }
    
    @ViewBuilder
    func buildSheet(sheet: Sheet) -> some View {
        switch sheet {
        case .search:
            SearchView { selectedSearchData in
                
            }
        }
    }
}
