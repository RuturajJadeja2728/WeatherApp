//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Ruturaj Jadeja on 6/4/23.
//

import UIKit
import RxSwift
import CoreLocation

final class WeatherViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var feelLikeLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var visibilityLabel: UILabel!
    
    @IBOutlet private weak var cloudImage: UIImageView!
    
    @IBOutlet private weak var unitsView: UIView!
    
    
    typealias ViewModel = AnyViewModel<WeatherViewModel.State, WeatherViewModel.Event>
    
    // MARK: - Private Variables
    
    private var viewModel: ViewModel
    
    init(viewModel: ViewModel = AnyViewModel(WeatherViewModel())) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
}

// MARK: - Configuration Methods

extension WeatherViewController {
    
    private func configuration() {
        
        configNavigationBar()
        bindViewModel()
        
        // Get updated location from Location Manager class
        
        LocationManager.shared.getUpdatedLocation = { [weak self] currentLocation in
            
            guard let self = self else {
                return
            }
            
            self.getSelectedLocation(currentLocation: currentLocation)
        }
    }

    private func configNavigationBar() {
        
        configureNavigationBar(
            title: "Weather",
            rightNavigationItems: [
                UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(searchButtonTapped))
            ]
        )
    }
    
    @objc private func searchButtonTapped() {
        
        let viewModel = AnyViewModel(SearchViewModel())
        let controller = SearchViewController(viewModel: viewModel)
        
        controller.selectedItem = { [weak self] item in
            
            guard let self = self else {
                return
            }
            
            self.storeSelectedLocation(location: item)
            self.viewModel.onReceiveEvent(.onSearchItem(item.lat, item.lon))
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func configDataWith(weather: WeatherData) {
        
        unitsView.layer.cornerRadius = 8
        unitsView.backgroundColor = .lightGray
        
        locationLabel.text = (weather.name ?? "") + ", " + (weather.sys?.country ?? "")
        
        descriptionLabel.text = weather.weather?.first?.description
        
        mainLabel.text = weather.weather?.first?.main
        
        let temperature = (Int)(floor(weather.main?.temp ?? 0))
        temperatureLabel.text = "\(temperature)°F"
        
        let feelsLike = (Int)(weather.main?.feelsLike ?? 0)
        feelLikeLabel.text = "Feels Like \(feelsLike)°F"
        
        windLabel.text = "Wind: \(weather.wind?.speed ?? 0)mph"
        humidityLabel.text = "Humidity: \(weather.main?.humidity ?? 0)%"
        pressureLabel.text = String(format: "Pressure: %.2finHg", (weather.main?.pressure ?? 0)/33.864)
        
        let distanceMeters = Measurement(value: weather.visibility ?? 0, unit: UnitLength.meters)
        let miles = distanceMeters.converted(to: UnitLength.miles).value
        visibilityLabel.text = String(format: "Visibility: %.2fmi", miles)
        
        if let url = URL(string: "\(CloudImageBaseURL)\(weather.weather?.first?.icon ?? "01d")@2x.png") {
            cloudImage.loadImage(url: url)
        }
    }
    
    private func bindViewModel() {
        
        // Whenever state change from viewModel then each time based on case value subscibe block will be called.
        
        viewModel.state
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (viewController, state) in
                
                switch state {
                    
                case .showLoading(let show):
                    self.showLoading(show)
                    
                case .showWeatherData(let weather):
                    self.configDataWith(weather: weather)
                }
            })
            .disposed(by: disposeBag)
        
        // Use this event when you want to implement when viewDidLoad
        
        viewModel.onReceiveEvent(.viewDidLoad)
    }
}

// MARK: - Manage Location Data

extension WeatherViewController {
    
    private func storeSelectedLocation(location: SearchResponse) {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(location) {
            AppUserDefaults.set(encoded, forKey: UserDefaultSelectedLocation)
        }
    }
    
    private func getSelectedLocation(currentLocation: CLLocationCoordinate2D?) {
        
        showLoading(true)
        
        if let savedLocation = AppUserDefaults.object(forKey: UserDefaultSelectedLocation) as? Data {
            
            let decoder = JSONDecoder()
            if let selectedLocation = try? decoder.decode(SearchResponse.self, from: savedLocation) {
                viewModel.onReceiveEvent(.onSearchItem(selectedLocation.lat, selectedLocation.lon))
            }
        } else {
            
            if let currentLocation = currentLocation {
                viewModel.onReceiveEvent(.onSearchItem(currentLocation.latitude, currentLocation.longitude))
            } else {
                viewModel.onReceiveEvent(.onSearchItem(DefaultLatitude, DefaultLongitude))
            }
        }
    }
}
