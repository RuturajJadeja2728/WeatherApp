//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Ruturaj Jadeja on 6/4/23.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController, NVActivityIndicatorViewable {
    
    let disposeBag = DisposeBag()
    let presenter = NVActivityIndicatorPresenter()
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    init(isNib: Bool = true) {
        if isNib {
            let nibName = String(describing: type(of: self))
            let bundle = Bundle(for: type(of: self))
            super.init(nibName: nibName, bundle: bundle)
        } else {
            super.init(nibName: nil, bundle: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func showLoading(_ show: Bool) {
        if show {
            startAnimating(presenter, size: CGSize(width: 45, height: 45), type: .ballSpinFadeLoader, color: .white, backgroundColor: .lightGray)
        } else {
            stopAnimating(presenter)
        }
    }
    
    func configureNavigationBar(
        title: String = "",
        barTintColor: UIColor = .white,
        leftNavigationItems: [UIBarButtonItem] = [],
        rightNavigationItems: [UIBarButtonItem] = []
    ) {
        
        self.navigationItem.title = title
        
        navigationItem.leftBarButtonItems = leftNavigationItems
        navigationItem.rightBarButtonItems = rightNavigationItems
        
        if leftNavigationItems.isEmpty {
            navigationItem.setHidesBackButton(true, animated: false)
        }
        
        navigationController?.navigationBar.barTintColor = barTintColor
    }
    
    private func configureNavigationBar() {
        
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes

        navigationController?.navigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize.init(width: 0, height: -1)
        navigationController?.navigationBar.layer.shadowOpacity = 1
        navigationController?.navigationBar.layer.shadowRadius = 4
        navigationController?.navigationBar.layer.shadowPath = UIBezierPath(rect: navigationController?.navigationBar.bounds ?? .zero).cgPath
        
        // Hide backbutton title
        navigationItem.backButtonDisplayMode = .minimal
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .purple
        appearance.shadowImage = UIImage()
        appearance.titleTextAttributes = titleTextAttributes
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
