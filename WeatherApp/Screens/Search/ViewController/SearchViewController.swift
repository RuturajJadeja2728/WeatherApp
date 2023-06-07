//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Ruturaj Jadeja on 6/4/23.
//

import UIKit
import RxSwift

final class SearchViewController: BaseViewController {
    
    typealias ViewModel = AnyViewModel<SearchViewModel.State, SearchViewModel.Event>
    
    // MARK: - IBOutlets

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchTableView: UITableView!
    
    // MARK: - Private Variables
    
    private(set) var searchResult = [SearchResponse]() {
        didSet {
            DispatchQueueMain.async {
                self.searchTableView.reloadData()
            }
        }
    }
    
    private var viewModel: ViewModel
    
    // MARK: - Public Variables
    
    var selectedItem: ((SearchResponse) -> Void)?
    
    init(viewModel: ViewModel = AnyViewModel(SearchViewModel())) {
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

extension SearchViewController {
    
    private func configuration() {
        
        configNavigationBar()
        configSearchTextField()
        configTableView()
        bindViewModel()
    }

    private func configNavigationBar() {
        self.title = "Search"
    }
    
    private func configSearchTextField() {
        
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.borderWidth = 2
        searchTextField.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func configTableView() {
        
        searchTableView.register(SearchResultTableViewCell.nib, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = 60
    }
    
    private func bindViewModel() {
        
        // Whenever state change from viewModel then each time based on case value subscibe block will be called.
        
        viewModel.state
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (viewController, state) in
                
                switch state {
                    
                case .getSearchData(let data):
                    self.searchResult = data
                }
            })
            .disposed(by: disposeBag)
        
        // Use this event when you want to implement when viewDidLoad
        
        self.viewModel.onReceiveEvent(.viewDidLoad)
    }
}

// MARK: - UITextField Delegate

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchTextField.resignFirstResponder()
        if !(textField.text?.isEmpty ?? false) {
            viewModel.onReceiveEvent(.onReturnTapped(textField.text ?? ""))
        }
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        navigationController?.popViewController(animated: true)
        return true
    }
}


// MARK: - Tableview Delegate and Datasource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        searchResult.count == 0 ? tableView.setEmptyMessage(NoResultFoundMessage) : tableView.restore()
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell {
            cell.configureData(item: searchResult[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = searchResult[indexPath.row]
        selectedItem?(item)
        navigationController?.popViewController(animated: true)
    }
}
